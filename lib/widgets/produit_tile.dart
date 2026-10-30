
import 'package:flutter/material.dart';

import '../models/produit.dart';

class ProduitTile extends StatelessWidget {
  final Produit produit;
  final VoidCallback onTap;

  const ProduitTile({
    super.key,
    required this.produit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      // Quantité dans un cercle
      leading: CircleAvatar(
        backgroundColor:
            produit.quantite == 0 ? Colors.red : Colors.green,
        child: Text(
          produit.quantite.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Nom du produit
      title: Text(produit.nom),

      // Prix du produit
      subtitle: Text(
        '${produit.prix.toStringAsFixed(3)} DT',
      ),

      // Disponibilité
      trailing: Icon(
        produit.disponible
            ? Icons.check_circle
            : Icons.cancel,
        color: produit.disponible
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}
