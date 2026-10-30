
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/produit.dart';
import 'database_helper.dart';

class ProduitDao {
  static const String table = 'produits';

  // Insérer un produit
  Future<int> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;

    final int id = await db.insert(
      table,
      produit.toMap(),
    );

    return id;
  }

  // Lire tous les produits triés par nom
  Future<List<Produit>> lireProduits() async {
    debugPrint('Lecture des produits dans SQLite');

    final db = await DatabaseHelper().database;

    final lignes = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return lignes
        .map((ligne) => Produit.fromMap(ligne))
        .toList();
  }

  // Lire un produit par son ID
  Future<Produit?> lireProduitParId(int id) async {
    final db = await DatabaseHelper().database;

    final lignes = await db.query(
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
}
