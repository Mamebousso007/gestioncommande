import 'package:cloud_firestore/cloud_firestore.dart';

import 'DetailCommande.dart';

class Commande {
  String id;
  String clientId;
  DateTime date;
  List<DetailCommande> details;
  double montantTotal;
  String modeDeLivraison; // Nouveau champ pour le mode de livraison
  String modeDePaiement;
  String nomClient;
  String telephoneCli;
  String adresseCli;// Nouveau champ pour le mode de paiement

  Commande({
    required this.id,
    required this.clientId,
    required this.date,
    required this.details,
    required this.montantTotal,
    required this.modeDeLivraison, // Ajout du mode de livraison
    required this.modeDePaiement,
    required this.nomClient,
    required this.telephoneCli,
    required this.adresseCli// Ajout du mode de paiement
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'date': date,
      'details': details.map((detail) => detail.toMap()).toList(),
      'montantTotal': montantTotal,
      'modeDeLivraison': modeDeLivraison,
      'modeDePaiement': modeDePaiement,
      'nomClient' : nomClient,
      'telephoneCli' : telephoneCli,
      'adresseCli' : adresseCli,
    };
  }
  // Convertir un DocumentSnapshot en Commande
  factory Commande.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Commande(
      id: doc.id,
      clientId: doc['clientId'],
      date: (doc['date'] as Timestamp).toDate(),
      details: (doc['details'] as List).map((detail) => DetailCommande.fromMap(detail)).toList(),
      montantTotal: doc['montantTotal'].toDouble(),
      modeDeLivraison: doc['modeDeLivraison'],
      modeDePaiement: doc['modeDePaiement'],
      nomClient:  doc['nomClient'],
      telephoneCli:  doc['telephoneCli'],
      adresseCli:  doc['adresseCli'],
    );
  }

}
