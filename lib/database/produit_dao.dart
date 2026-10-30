import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/produit.dart';
import 'database_helper.dart';

class ProduitDao {
  static const String table = 'produits';

  Future<int> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;

    return await db.insert(
      table,
      produit.toMap(),
    );
  }

  Future<List<Produit>> lireProduits() async {
    final Database db = await DatabaseHelper().database;

    debugPrint('Lecture des produits dans SQLite');

    final List<Map<String, dynamic>> lignes = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return lignes.map((ligne) => Produit.fromMap(ligne)).toList();
  }

  Future<Produit?> lireProduitParId(int id) async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> lignes = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (lignes.isEmpty) {
      return null;
    }

    return Produit.fromMap(lignes.first);
  }

  // Modification complète d'un produit
  Future<int> modifierProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;

    return await db.update(
      table,
      produit.toMap(),
      where: 'id = ?',
      whereArgs: [produit.id],
    );
  }

  // Modification de la disponibilité uniquement
  Future<int> changerDisponibilite(
    int id,
    bool disponible,
  ) async {
    final Database db = await DatabaseHelper().database;

    return await db.update(
      table,
      {
        'disponible': disponible ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Augmenter ou diminuer la quantité
  Future<int> ajusterQuantite(int id, int delta) async {
    final Database db = await DatabaseHelper().database;

    return await db.rawUpdate(
      'UPDATE produits SET quantite = quantite + ? '
      'WHERE id = ? AND quantite + ? >= 0',
      [delta, id, delta],
    );
  }
}