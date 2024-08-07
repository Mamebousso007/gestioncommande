import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'detailspanier.dart';

class Panier with ChangeNotifier{
  final List<DetailsPanier> produits = [];
  CollectionReference _panierCollection = FirebaseFirestore.instance.collection('Panier');
  Future<void> ajouterAuPanier(DetailsPanier produit) async {
    try {
      final newDocumentRef = _panierCollection.doc();
      await newDocumentRef.set({
        'id': newDocumentRef.id,
        'nom': produit.nom,
        'prix': produit.prix,
        'produitID': produit.id,
        'image': produit.image,
        'taille': produit.taille,
        'quantite': produit.quantite,
      });
      produits.add(produit);
      incrementerPanier();
      // Ensuite, vous informez tous les listeners de la mise à jour
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'ajout au panier : $e');
    }
  }

  int nombreProduits = 0; // Nombre d'articles dans le panier
  Panier() {
    recupererDonneesPanierEtMettreAJour();
  }
  // Cette fonction incrémente le nombre d'articles dans le panier
  void incrementerPanier() {
    nombreProduits++;
    notifyListeners(); // Informez les auditeurs du changement
  }

  bool contientProduit(DetailsPanier produit) {
    return produits.contains(produit);
  }
  Future<void> recupererDonneesPanierEtMettreAJour() async {
    final produitsRecuperes = await recupererDonneesPanier();
    produits.clear();
    produits.addAll(produitsRecuperes);
    nombreProduits = produits.length;
    notifyListeners(); // Assurez-vous de notifier les listeners après le chargement des données
  }
  Future<List<DetailsPanier>> recupererDonneesPanier() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Panier').get();
      return querySnapshot.docs.map((doc) {
        return DetailsPanier(
          nom: doc['nom'],
          prix: doc['prix'],
          id: doc['id'],
          produitID: '', // Vous pouvez le remplir si vous en avez besoin
          image: doc['image'],
          taille: doc['taille'], // Assurez-vous de récupérer la taille depuis Firebase
          quantite: doc['quantite'], // Assurez-vous de récupérer la quantité depuis Firebase
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des produits du panier : $e');
      return [];
    }
  }
  double get montantTotal {
    double total = 0;
    for (var produit in produits) {
      total += produit.prix * produit.quantite;
    }
    return total;
  }

  Future<void> supprimerDuPanier(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('Panier').doc(productId).delete();
      produits.removeWhere((produit) => produit.id == productId);
      decrementerPanier();
      notifyListeners(); // Notifie les écouteurs après la suppression
    } catch (e) {
      print('Erreur lors de la suppression du produit du panier : $e');
    }
  }

  void decrementerPanier() {
    if (nombreProduits > 0) {
      nombreProduits--;
    }
  }

}
