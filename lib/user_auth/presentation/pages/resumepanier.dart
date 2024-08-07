import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DetailCommande.dart';
import 'commande.dart';
import 'panierModel.dart';

class ResumePanier extends StatefulWidget {
  const ResumePanier({Key? key, required  this.Montant}) : super(key: key);
  final double Montant;
  @override
  State<ResumePanier> createState() => _ResumePanierState();
}

class _ResumePanierState extends State<ResumePanier> {
  String deliveryOption = 'boutique';
  String paymentOption = 'Carte de crédit';


  void confirmerCommande() async {
    try {
      // Accès au panier à l'aide de Provider
      Panier panier = Provider.of<Panier>(context, listen: false);

      List<DetailCommande> detailsDuPanier = panier.produits.map((produitPanier) {
        print("Produit ID: ${produitPanier.produitID}, Nom: ${produitPanier.nom}");
        return DetailCommande(
          produitId: produitPanier.produitID,
          nomProduit: produitPanier.nom,
          quantite: produitPanier.quantite,
          prixUnitaire: produitPanier.prix,
          imageUrl: produitPanier.image,
        );
      }).toList();
      print("Détails du panier: $detailsDuPanier"); // Debugging

      double montantTotal = widget.Montant;
      Future<Map<String, dynamic>?> _recupererInfoClient(String clientId) async {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(clientId).get();
          if (userDoc.exists) {
            return userDoc.data() as Map<String, dynamic>?;
          }
          return null;
        } catch (e) {
          print("Erreur lors de la récupération des informations du client: $e");
          return null;
        }
      }
      var clientId = FirebaseAuth.instance.currentUser!.uid;

      var clientInfo = await _recupererInfoClient(clientId);
      // Création et enregistrement de la commande
      Commande nouvelleCommande = Commande(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientId: clientId,
        nomClient: clientInfo?['username'],
        telephoneCli: clientInfo?['Telephone']??'',
        adresseCli: clientInfo?['Adresse'] ?? '',
        date: DateTime.now(),
        details: detailsDuPanier,
        montantTotal: montantTotal,
        modeDeLivraison: deliveryOption,
        modeDePaiement: paymentOption,


      );
      await FirebaseFirestore.instance.collection('commandes').doc(nouvelleCommande.id).set(nouvelleCommande.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Commande passée avec succès !")));
      // Redirection ou mise à jour de l'UI ici
    } catch (e) {
      print("Erreur lors de la création de la commande: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de la commande")));
    }
  }


  /*void confirmerCommande(Panier panier) async {
    try {
      // Convertir les détails du panier en détails de commande
      List<DetailCommande> detailsDuPanier = panier.produits.map((produitPanier) {
        return DetailCommande(
          produitId: produitPanier.produitID,
          nomProduit: produitPanier.nom,
          quantite: produitPanier.quantite,
          prixUnitaire: produitPanier.prix,
        );
      }).toList();

      double montantTotal = panier.montantTotal;

      // Création et enregistrement de la commande
      Commande nouvelleCommande = Commande(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientId: FirebaseAuth.instance.currentUser!.uid,
        date: DateTime.now(),
        details: detailsDuPanier,
        montantTotal: montantTotal,
        modeDeLivraison: deliveryOption,
        modeDePaiement: paymentOption,
      );

      await FirebaseFirestore.instance.collection('commandes').doc(nouvelleCommande.id).set(nouvelleCommande.toMap());

      // Notification de succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Commande passée avec succès !")));
      // Redirection ou mise à jour de l'UI ici
    } catch (e) {
      print("Erreur lors de la création de la commande: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de la commande")));
    }
  }*/
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Center(child: Text('Résumé commande',style: TextStyle(color: Colors.black, fontSize: 16,), )),
        backgroundColor: Color(0xFFFAF7F7),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 460,
              height: 76,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 22,
                    top: 15,
                    child: SizedBox(
                      width: 159,
                      height: 28,
                      child: Text(
                        'Total articles (2)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 272,
                    top: 15,
                    child: SizedBox(
                      width: 131,
                      height: 28,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.Montant} ',
                              style: TextStyle(
                                color: Color(0xFFF00808),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: 'Fcfa',
                              style: TextStyle(
                                color: Color(0xFFF00808),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Text('${widget.Montant} FCFA'),
            SizedBox(height: 20),
            Text(
              'Mode de livraison:',
              style: TextStyle(
                fontSize: 18, // Augmenter la taille du texte
                fontWeight: FontWeight.bold, // Rendre le texte en gras
                color: Color(0xFFEC729C), // Changer la couleur du texte
                letterSpacing: 0.5, // Espacer légèrement les lettres
                // Ajouter plus de styles si nécessaire
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 416,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text('A la boutique'),
                    value: 'boutique',
                    groupValue: deliveryOption,
                    onChanged: (value) {
                      setState(() {
                        deliveryOption = value!;
                      });
                    },
                    activeColor: Color(0xFFEC729C),
                  ),
                  RadioListTile(
                    title: Text('Livraison à domicile'),
                    value: 'domicile',
                    groupValue: deliveryOption,
                    onChanged: (value) {
                      setState(() {
                        deliveryOption = value!;
                      });
                    },
                    activeColor: Color(0xFFEC729C),
                  ),

                ],
              ),
            ),


            SizedBox(height: 20),
            Text(
              'Mode de paiement:',
              style: TextStyle(
                fontSize: 18, // Augmenter la taille du texte
                fontWeight: FontWeight.bold, // Rendre le texte en gras
                color: Color(0xFFEC729C), // Changer la couleur du texte
                letterSpacing: 0.5, // Espacer légèrement les lettres
                // Ajouter plus de styles si nécessaire
              ),
            ),

            SizedBox(height: 20),
            Container(
              width: 416,
              height: 190,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text('Paiement à la livraison'),
                    value: 'livraison',
                    groupValue: paymentOption,
                    onChanged: (value) {
                      setState(() {
                        paymentOption = value!;
                      });
                    },
                    activeColor: Color(0xFFEC729C),
                  ),
                  RadioListTile(
                    title: Text('Wave'),
                    value: 'Wave',
                    groupValue: paymentOption,
                    secondary: Image.asset(
                      'images/logowv.png',
                      width: 22,
                      height: 22,
                      fit: BoxFit.cover,
                    ),
                    onChanged: (value) {
                      setState(() {
                        paymentOption = value!;
                      });
                    },
                    activeColor: Color(0xFFEC729C),
                  ),
                  RadioListTile(
                    title: Text('Orange Money'),
                    value: 'OrangeMoney',
                    groupValue: paymentOption,
                    secondary: Image.asset(
                      'images/logoom.png',
                      width: 22,
                      height: 22,
                      fit: BoxFit.cover,
                    ),
                    onChanged: (value) {
                      setState(() {
                        paymentOption = value!;
                      });
                    },
                    activeColor: Color(0xFFEC729C),
                  ),

                ],
              ),
            ),



            SizedBox(height: 20),
            ElevatedButton(
              onPressed: confirmerCommande,
              child: Text('Confirmer la commande'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFEC729C),
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),

    );
  }
}
