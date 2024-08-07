import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produit.dart';

class Details extends StatefulWidget {
  final Produit produit; // Le produit actuel à afficher

  Details({required this.produit});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(imageUrl, fit: BoxFit.contain),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFBB9B9)),
        title: Text("Détails du Produit", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Image(
            image: AssetImage("images/logo.jpg"),
            height: 40,
            width: 40,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _showImageDialog(widget.produit.image!),
                child: Image.network(
                  widget.produit.image!,
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom: ${widget.produit.nom}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Catégorie: ${widget.produit.categorie}', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('Description: ${widget.produit.description}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Prix: ${widget.produit.prixvente} FCFA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFBB9B9))),
                  SizedBox(height: 10),
                  Text('Stocks: ${widget.produit.stock}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Taille: ${widget.produit.taille}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Remise: ${widget.produit.remise}%', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Ajoutez ici la logique pour modifier le produit
                        },
                        child: Text("Modifier",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Couleur du bouton
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Ajoutez ici la logique pour supprimer le produit
                        },
                        child: Text("Supprimer",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF68B73), // Couleur du bouton
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
