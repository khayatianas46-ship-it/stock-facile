
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  // Q3 : Ouvrir la base et compter les catégories
  Future<void> ouvrirBase() async {
    final db = await DatabaseHelper().database;

    final resultat = await db.rawQuery(
      'SELECT COUNT(*) AS nb FROM categories',
    );

    debugPrint('Nombre de catégories : ${resultat.first['nb']}');
  }

  // Q4.3 et Q4.4 : Insérer une catégorie et gérer les doublons
  Future<void> testerInsertionCategorie(BuildContext context) async {
    final nouvelle = Categorie(
      nom: 'Électroménager',
      description: 'Petits appareils',
    );

    try {
      final id = await CategorieDao().insererCategorie(nouvelle);

      debugPrint('Catégorie insérée avec l id $id');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catégorie ajoutée avec succès. ID : $id'),
        ),
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cette catégorie existe déjà'),
          ),
        );
      } else {
        debugPrint('Erreur SQLite : $e');
      }
    }
  }

  // Q4.8 : Insérer un produit
  Future<void> testerInsertionProduit() async {
    final produit = Produit(
      nom: 'Stylo bleu',
      prix: 0.500,
      quantite: 100,
      disponible: true,
      dateAjout: DateTime.now(),
      categorieId: 4,
    );

    try {
      final id = await ProduitDao().insererProduit(produit);
      debugPrint('Produit inséré avec l id $id');
    } on DatabaseException catch (e) {
      debugPrint('Erreur SQLite : $e');
    }
  }

  // Q4.10 : Tester une clé étrangère invalide
  Future<void> testerCleEtrangere() async {
    final produit = Produit(
      nom: 'Produit test FK',
      prix: 5.0,
      quantite: 10,
      disponible: true,
      dateAjout: DateTime.now(),
      categorieId: 99,
    );

    try {
      final id = await ProduitDao().insererProduit(produit);
      debugPrint('Produit inséré avec l id $id');
    } on DatabaseException catch (e) {
      debugPrint('Erreur SQLite : $e');
    }
  }

  // Q4.11 : Tester un prix négatif
  Future<void> testerPrixNegatif() async {
    final produit = Produit(
      nom: 'Produit prix négatif',
      prix: -2,
      quantite: 5,
      disponible: true,
      dateAjout: DateTime.now(),
      categorieId: 4,
    );

    try {
      final id = await ProduitDao().insererProduit(produit);
      debugPrint('Produit inséré avec l id $id');
    } on DatabaseException catch (e) {
      debugPrint('Erreur SQLite : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests StockFacile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: ouvrirBase,
            child: const Text('Ouvrir la base'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => testerInsertionCategorie(context),
            child: const Text('Test : ajouter une catégorie'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerInsertionProduit,
            child: const Text('Test : ajouter un produit'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerCleEtrangere,
            child: const Text('Test : clé étrangère'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerPrixNegatif,
            child: const Text('Test : prix négatif'),
          ),
        ],
      ),
    );
  }
}
