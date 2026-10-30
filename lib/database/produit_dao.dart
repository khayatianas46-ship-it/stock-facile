import 'package:sqflite/sqflite.dart';
import '../models/produit.dart';
import 'database_helper.dart';

class ProduitDao {
  static const String table = 'produits';

  Future<int> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;
    final int id = await db.insert(table, produit.toMap());
    return id;
  }
}
