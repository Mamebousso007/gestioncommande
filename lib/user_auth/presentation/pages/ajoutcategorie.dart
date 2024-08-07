import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AjoutCategorie extends StatefulWidget {
  const AjoutCategorie({Key? key}) : super(key: key);

  @override
  State<AjoutCategorie> createState() => _AjoutCategorieState();
}

class _AjoutCategorieState extends State<AjoutCategorie> {
  final TextEditingController nomCategorieController = TextEditingController();

  // Fonction pour ajouter la catégorie à Firestore
  void ajouterCategorieFirestore(String nomCategorie) {
    FirebaseFirestore.instance.collection('Categories').add({
      'nom': nomCategorie,

    })
        .then((value) {
      print("Catégorie ajoutée avec succès !");
    })
        .catchError((error) {
      print("Erreur lors de l'ajout de la catégorie : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Text("Ajouter Catégorie",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            )),
        actions: [
          Text("Logo", style: TextStyle(color: Colors.black),)
        ],
        centerTitle: true,
        backgroundColor: Color(0xFFFAF7F7),
        elevation: 0,
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              height: 37,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0x75FF18BE)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextFormField(
                controller: nomCategorieController,
                textAlign: TextAlign.center, // Pour centrer le texte
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none, // Pour supprimer la bordure par défaut du TextFormField
                  hintText: 'Nom Categorie', // Texte à l'intérieur du champ
                  hintStyle: TextStyle(
                    color: Color(0xA3554E4E),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () {
                // Récupérez le texte du champ de saisie
                String nomCategorie = nomCategorieController.text;

                // Appelez la fonction pour ajouter la catégorie
                ajouterCategorieFirestore(nomCategorie);

                // Vous pouvez ajouter ici du code pour réinitialiser le champ de saisie ou effectuer d'autres actions après l'ajout.
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF209A01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Valider',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
