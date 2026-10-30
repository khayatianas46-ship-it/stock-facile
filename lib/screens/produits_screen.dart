import 'package:flutter/material.dart';

import '../models/produit.dart';
import '../database/produit_dao.dart';
import '../widgets/produit_tile.dart';
import 'produit_form_screen.dart';
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
    _futurProduits = _dao.lireProduits();
  }

  Future<void> _rafraichir() async {
    final future = _dao.lireProduits();

    setState(() {
      _futurProduits = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder affichera l'erreur.
    }
  }

  Future<void> _ouvrirFormulaire() async {
    final ajoute = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ProduitFormScreen(),
      ),
    );

    if (!mounted) return;

    if (ajoute == true) {
      await _rafraichir();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit ajouté'),
        ),
      );
    }
  }

  Future<void> _ouvrirDetail(Produit produit) async {
    if (produit.id == null) return;

    final modifie = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProduitDetailScreen(
          produitId: produit.id!,
        ),
      ),
    );

    if (!mounted) return;

    if (modifie == true) {
      await _rafraichir();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
      ),
      body: FutureBuilder<List<Produit>>(
        future: _futurProduits,
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

          final produits = snapshot.data ?? [];

          if (produits.isEmpty) {
            return RefreshIndicator(
              onRefresh: _rafraichir,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Center(
                    child: Text('Aucun produit disponible'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _rafraichir,
            child: ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final produit = produits[index];

                return ProduitTile(
                  produit: produit,
                  onTap: () => _ouvrirDetail(produit),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaire,
        tooltip: 'Ajouter un produit',
        child: const Icon(Icons.add),
      ),
    );
  }
}