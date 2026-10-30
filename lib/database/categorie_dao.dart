
import 'package:sqflite/sqflite.dart';

import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

  // Insérer une catégorie
  Future<int> insererCategorie(Categorie categorie) async {
    final Database db = await DatabaseHelper().database;

    final int id = await db.insert(
      table,
      categorie.toMap(),
    );

    return id;
  }

  // Lire toutes les catégories triées par nom
  Future<List<Categorie>> lireCategories() async {
    final db = await DatabaseHelper().database;

    final lignes = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return lignes
        .map((ligne) => Categorie.fromMap(ligne))
        .toList();
  }

  // Lire une catégorie par son ID
  Future<Categorie?> lireCategorieParId(int id) async {
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

    return Categorie.fromMap(lignes.first);
  }
}
