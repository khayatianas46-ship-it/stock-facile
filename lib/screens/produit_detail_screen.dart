import 'package:flutter/material.dart';

import '../models/produit.dart';
import '../models/categorie.dart';
import '../database/produit_dao.dart';
import '../database/categorie_dao.dart';
import 'produit_form_screen.dart';

class ProduitDetailData {
  final Produit produit;
  final Categorie? categorie;

  const ProduitDetailData({
    required this.produit,
    required this.categorie,
  });
}

class ProduitDetailScreen extends StatefulWidget {
  final int produitId;

  const ProduitDetailScreen({
    super.key,
    required this.produitId,
  });

  @override
  State<ProduitDetailScreen> createState() =>
      _ProduitDetailScreenState();
}

class _ProduitDetailScreenState
    extends State<ProduitDetailScreen> {
  final ProduitDao _produitDao = ProduitDao();
  final CategorieDao _categorieDao = CategorieDao();

  late Future<ProduitDetailData?> _futurDetails;

  @override
  void initState() {
    super.initState();
    _futurDetails = _chargerDetails();
  }

  Future<ProduitDetailData?> _chargerDetails() async {
    final produit = await _produitDao.lireProduitParId(
      widget.produitId,
    );

    if (produit == null) {
      return null;
    }

    final categorie = await _categorieDao.lireCategorieParId(
      produit.categorieId,
    );

    return ProduitDetailData(
      produit: produit,
      categorie: categorie,
    );
  }

  Future<void> _recharger() async {
    setState(() {
      _futurDetails = _chargerDetails();
    });

    try {
      await _futurDetails;
    } catch (_) {
      // FutureBuilder affichera l'erreur.
    }
  }

  String _formaterDate(DateTime date) {
    final jour = date.day.toString().padLeft(2, '0');
    final mois = date.month.toString().padLeft(2, '0');

    return '$jour/$mois/${date.year}';
  }

  Future<void> _modifierProduit(Produit produit) async {
    final resultat = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProduitFormScreen(
          produit: produit,
        ),
      ),
    );

    if (!mounted) return;

    if (resultat == true) {
      await _recharger();
    }
  }

  Future<void> _ajusterQuantite(
    Produit produit,
    int delta,
  ) async {
    if (produit.id == null) return;

    try {
      final resultat = await _produitDao.ajusterQuantite(
        produit.id!,
        delta,
      );

      if (resultat == 0 && delta < 0) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La quantité ne peut pas être négative'),
          ),
        );

        return;
      }

      // Relire le produit après la modification.
      final produitActualise =
          await _produitDao.lireProduitParId(produit.id!);

      if (produitActualise != null &&
          produitActualise.quantite == 0) {
        await _produitDao.changerDisponibilite(
          produit.id!,
          false,
        );
      }

      if (!mounted) return;

      await _recharger();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Détail du produit'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: FutureBuilder<ProduitDetailData?>(
          future: _futurDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erreur : ${snapshot.error}'),
              );
            }

            final details = snapshot.data;

            if (details == null) {
              return const Center(
                child: Text('Produit introuvable'),
              );
            }

            final produit = details.produit;
            final categorie = details.categorie;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              produit.nom,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Modifier le produit',
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _modifierProduit(produit),
                          ),
                        ],
                      ),

                      const Divider(height: 24),

                      _ligneDetail(
                        'Prix',
                        '${produit.prix.toStringAsFixed(3)} DT',
                      ),

                      _ligneDetail(
                        'Quantité',
                        produit.quantite.toString(),
                      ),

                      _ligneDetail(
                        'Disponibilité',
                        produit.disponible
                            ? 'Disponible'
                            : 'Indisponible',
                      ),

                      _ligneDetail(
                        'Catégorie',
                        categorie?.nom ?? 'Inconnue',
                      ),

                      _ligneDetail(
                        'Date d’ajout',
                        _formaterDate(produit.dateAjout),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Gérer la quantité',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () =>
                                _ajusterQuantite(produit, -1),
                            icon: const Icon(Icons.remove),
                          ),

                          const SizedBox(width: 24),

                          Text(
                            '${produit.quantite}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 24),

                          IconButton.filled(
                            onPressed: () =>
                                _ajusterQuantite(produit, 1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _ligneDetail(String titre, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valeur,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}