
import 'package:flutter/material.dart';

import '../database/produit_dao.dart';
import '../models/produit.dart';
import '../widgets/produit_tile.dart';
import 'produit_detail_screen.dart';

class ProduitsScreen extends StatefulWidget {
  const ProduitsScreen({super.key});

  @override
  State<ProduitsScreen> createState() => _ProduitsScreenState();
}

class _ProduitsScreenState extends State<ProduitsScreen> {
  final ProduitDao _dao = ProduitDao();

  late Future<List<Produit>> _futurProduits;

  @override
  void initState() {
    super.initState();

    // Charger les produits au démarrage
    _futurProduits = _dao.lireProduits();
  }

  // Actualiser la liste
  Future<void> _rafraichir() async {
  final future = _dao.lireProduits();

  setState(() {
    _futurProduits = future;
  });

  try {
    await future;
  } catch (_) {
    // L'erreur sera affichée par le FutureBuilder.
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
      ),

      body: FutureBuilder<List<Produit>>(
        future: _futurProduits,

        builder: (context, snapshot) {
          // 1. Chargement en cours
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Erreur
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          // 3. Liste vide
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return RefreshIndicator(
              onRefresh: _rafraichir,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text('Aucun produit'),
                  ),
                ],
              ),
            );
          }

          // 4. Données reçues
          final produits = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _rafraichir,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: produits.length,

              itemBuilder: (context, index) {
                final produit = produits[index];

                return ProduitTile(
                  produit: produit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProduitDetailScreen(
                            produitId: produit.id!,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
