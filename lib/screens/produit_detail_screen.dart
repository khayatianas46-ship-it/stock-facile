
import 'package:flutter/material.dart';

import '../database/produit_dao.dart';
import '../database/categorie_dao.dart';
import '../models/produit.dart';
import '../models/categorie.dart';

// Contient le produit et sa catégorie
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

  // Charger le produit et sa catégorie depuis SQLite
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

  // Convertir la date au format jj/mm/aaaa
  String formaterDate(DateTime date) {
    final jour = date.day.toString().padLeft(2, '0');
    final mois = date.month.toString().padLeft(2, '0');
    final annee = date.year.toString();

    return '$jour/$mois/$annee';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du produit'),
      ),

      body: FutureBuilder<ProduitDetailData?>(
        future: _futurDetails,

        builder: (context, snapshot) {
          // Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Erreur
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Produit introuvable
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Produit introuvable'),
            );
          }

          final details = snapshot.data!;
          final produit = details.produit;
          final categorie = details.categorie;

          // Afficher les informations
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produit.nom,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),

                    const Divider(height: 30),

                    Text(
                      'Prix : ${produit.prix.toStringAsFixed(3)} DT',
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Quantité : ${produit.quantite}',
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Disponibilité : ${produit.disponible ? "Disponible" : "Indisponible"}',
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Catégorie : ${categorie?.nom ?? "Catégorie inconnue"}',
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Date d ajout : ${formaterDate(produit.dateAjout)}',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
