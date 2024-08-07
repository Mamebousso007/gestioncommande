class DetailCommande {
  String produitId;
  String nomProduit;
  num quantite;
  num prixUnitaire;
  num prixTotal; // Calculé comme quantite * prixUnitaire
  String imageUrl; // URL de l'image du produit

  DetailCommande({
    required this.produitId,
    required this.nomProduit,
    required this.quantite,
    required this.prixUnitaire,
    required this.imageUrl, // Ajout de l'URL de l'image
  }) : prixTotal = quantite * prixUnitaire;

  Map<String, dynamic> toMap() {
    return {
      'produitId': produitId,
      'nomProduit': nomProduit,
      'quantite': quantite,
      'prixUnitaire': prixUnitaire,
      'prixTotal': prixTotal,
      'imageUrl': imageUrl, // Inclure l'URL de l'image dans la Map
    };
  }

  factory DetailCommande.fromMap(Map<String, dynamic> map) {
    var imageUrl = map['imageUrl'] ?? '';
    print("Image URL from Firestore: $imageUrl");
    return DetailCommande(
      produitId: map['produitId'] ?? '',
      quantite: map['quantite'] ?? 0,
      prixUnitaire: map['prixUnitaire']?.toDouble() ?? 0.0,
      nomProduit: map['nomProduit'] ?? '',
      imageUrl: map['imageUrl'] ?? '', // Assurez-vous d'inclure ce champ
    );
  }

}
