import 'package:flutter/material.dart';

import '../models/produit.dart';
import '../models/categorie.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';

class ProduitFormScreen extends StatefulWidget {
  final Produit? produit;

  const ProduitFormScreen({
    super.key,
    this.produit,
  });

  @override
  State<ProduitFormScreen> createState() => _ProduitFormScreenState();
}

class _ProduitFormScreenState extends State<ProduitFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController =
      TextEditingController();

  final CategorieDao _categorieDao = CategorieDao();
  final ProduitDao _produitDao = ProduitDao();

  late Future<List<Categorie>> _categoriesFuture;

  int? _categorieId;
  bool _disponible = true;
  bool _enregistrement = false;

  bool get _modeModification => widget.produit != null;

  @override
  void initState() {
    super.initState();

    _categoriesFuture = _categorieDao.lireCategories();

    if (widget.produit != null) {
      final produit = widget.produit!;

      _nomController.text = produit.nom;
      _prixController.text = produit.prix.toString();
      _quantiteController.text = produit.quantite.toString();

      _categorieId = produit.categorieId;
      _disponible = produit.disponible;
    } else {
      _quantiteController.text = '0';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _quantiteController.dispose();

    super.dispose();
  }

  String? _validerNom(String? valeur) {
    if (valeur == null || valeur.trim().isEmpty) {
      return 'Le nom est obligatoire';
    }

    if (valeur.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    return null;
  }

  String? _validerPrix(String? valeur) {
    if (valeur == null || valeur.trim().isEmpty) {
      return 'Le prix est obligatoire';
    }

    final prix = double.tryParse(
      valeur.trim().replaceAll(',', '.'),
    );

    if (prix == null || prix <= 0) {
      return 'Saisissez un prix positif valide';
    }

    return null;
  }

  String? _validerQuantite(String? valeur) {
    if (valeur == null || valeur.trim().isEmpty) {
      return 'La quantité est obligatoire';
    }

    final quantite = int.tryParse(valeur.trim());

    if (quantite == null || quantite < 0) {
      return 'Saisissez un entier positif ou nul';
    }

    return null;
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_categorieId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir une catégorie'),
        ),
      );
      return;
    }

    final prix = double.parse(
      _prixController.text.trim().replaceAll(',', '.'),
    );

    final quantite = int.parse(
      _quantiteController.text.trim(),
    );

    setState(() {
      _enregistrement = true;
    });

    try {
      if (_modeModification) {
        final produitModifie = widget.produit!.copyWith(
          nom: _nomController.text.trim(),
          prix: prix,
          quantite: quantite,
          disponible: _disponible,
          categorieId: _categorieId,
        );

        await _produitDao.modifierProduit(produitModifie);
      } else {
        final nouveauProduit = Produit(
          nom: _nomController.text.trim(),
          prix: prix,
          quantite: quantite,
          disponible: _disponible,
          dateAjout: DateTime.now(),
          categorieId: _categorieId!,
        );

        await _produitDao.insererProduit(nouveauProduit);
      }

      if (!context.mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
        ),
      );

      setState(() {
        _enregistrement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _modeModification
              ? 'Modifier le produit'
              : 'Nouveau produit',
        ),
      ),
      body: FutureBuilder<List<Categorie>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(
              child: Text('Aucune catégorie disponible'),
            );
          }

          final int? categorieSelectionnee =
              categories.any((c) => c.id == _categorieId)
                  ? _categorieId
                  : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      prefixIcon: Icon(Icons.inventory_2),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validerNom,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _prixController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Prix (DT)',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validerPrix,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _quantiteController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validerQuantite,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    value: categorieSelectionnee,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((categorie) {
                      return DropdownMenuItem<int>(
                        value: categorie.id,
                        child: Text(categorie.nom),
                      );
                    }).toList(),
                    onChanged: (valeur) {
                      setState(() {
                        _categorieId = valeur;
                      });
                    },
                    validator: (valeur) {
                      if (valeur == null) {
                        return 'Veuillez choisir une catégorie';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  SwitchListTile(
                    title: const Text('Disponible à la vente'),
                    value: _disponible,
                    onChanged: (valeur) {
                      setState(() {
                        _disponible = valeur;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed:
                        _enregistrement ? null : _enregistrer,
                    icon: const Icon(Icons.save),
                    label: Text(
                      _enregistrement
                          ? 'Enregistrement...'
                          : 'Enregistrer',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}