import 'package:flutter/material.dart';

import '../database/produit_dao.dart';
import '../models/produit.dart';
import 'produits_screen.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final ProduitDao _produitDao = ProduitDao();

  String _message = 'Choisissez un test';

  Future<void> _testerModifierProduit() async {
    try {
      final Produit? produit =
          await _produitDao.lireProduitParId(1);

      if (produit == null) {
        setState(() {
          _message = 'Le produit 1 n’existe pas';
        });
        return;
      }

      final Produit produitModifie = produit.copyWith(
        prix: produit.prix + 1,
      );

      final int resultat =
          await _produitDao.modifierProduit(produitModifie);

      setState(() {
        _message =
            'Lignes modifiées : $resultat\n'
            'Ancien prix : ${produit.prix}\n'
            'Nouveau prix : ${produitModifie.prix} DT';
      });
    } catch (e) {
      setState(() {
        _message = 'Erreur : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests StockFacile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testerModifierProduit,
              child: const Text(
                'Modifier le prix du produit 1 (+1 DT)',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProduitsScreen(),
                  ),
                );
              },
              child: const Text('Afficher les produits'),
            ),

            const SizedBox(height: 24),

            const Text(
              'Résultat du test :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(_message),
          ],
        ),
      ),
    );
  }
}