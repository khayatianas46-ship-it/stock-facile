import 'package:sqflite/sqflite.dart';
import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

  Future<int> insererCategorie(Categorie categorie) async {
    // 1. Récupérer la connexion à la base de données.
    final Database db = await DatabaseHelper().database;

    // 2. Insérer la catégorie dans la table et récupérer son ID.
    final int id = await db.insert(table, categorie.toMap());

    // 3. Retourner l'ID de la catégorie insérée.
    return id;
  }
}