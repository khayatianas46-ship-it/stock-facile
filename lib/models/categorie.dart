class Categorie {
  final int? id;
  final String nom;
  final String? description;

  const Categorie({
    this.id,
    required this.nom,
    this.description,
  });

  factory Categorie.fromMap(Map<String, dynamic> map) {
    return Categorie(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'description': description,
    };
  }

  @override
  String toString() => 'Categorie(id: $id, nom: $nom)';
}