

class DetailsPanier {
  final String id; // Identifiant unique pour l'élément du panier
  final String produitID;
  final String nom;
  final num prix;
  final String image;
  final String taille;
   num quantite;

  DetailsPanier({
    required this.id, // Utilisez un identifiant unique
    required this.produitID,
    required this.nom,
    required this.prix,
    required this.image,
    required this.taille,
    required this.quantite,
  });

  // Une méthode pour convertir un objet Produit en Map (utile pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produitID': produitID,
      'nom': nom,
      'prix': prix,
      'image': image,
      'taille': taille,
      'quantite': quantite
    };
  }

  factory DetailsPanier.fromMap(Map<String, dynamic> map) {
    return DetailsPanier(
        id: map['id'],
        produitID: map['produitID'],
        nom: map['nom'],
        prix: map['prix'],
        image: map['image'],
        taille: map['taille'],
        quantite: map['quantite'],

    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailsPanier &&
        other.id == id &&
        other.taille == taille; // Comparez d'autres attributs si nécessaire.
  }

  @override
  int get hashCode {
    return id.hashCode ^ taille.hashCode; // Utilisez d'autres attributs si nécessaire.
  }

}
