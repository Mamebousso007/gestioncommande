class Produit {
  final String id;
   String nom;
   String description;
   num prixvente;
   String image;
   String categorie;
   num stock;
   num remise;
   String taille;

  Produit({
    required this.id,
    required this.nom,
    required this.description,
    required this.prixvente,
    required this.image,
    required this.categorie,
    required this.stock,
    required this.remise,
    required this.taille
  });

  // Une méthode pour convertir un objet Produit en Map (utile pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prixvente': prixvente,
      'image': image,
      'categorie': categorie,
      'stock': stock,
      'remise': remise,
      'taille': taille
    };
  }

  // Une méthode pour créer un objet Produit à partir d'un Map (récupéré de Firestore)
  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'],
      nom: map['nom'],
      description: map['description'],
      prixvente: map['prixvente'],
      image: map['image'],
      categorie: map['categorie'],
      stock: map['stock'],
      remise: map['remise'],
      taille: map['taille']
    );
  }
}

/*

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries
// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCvm4wIQxuhBcK4jL-bE60vScTcU8hfP90",
  authDomain: "gestion-commande2.firebaseapp.com",
  projectId: "gestion-commande2",
  storageBucket: "gestion-commande2.appspot.com",
  messagingSenderId: "115080539774",
  appId: "1:115080539774:web:4137928e55dcaa5ec8f22f"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
 */