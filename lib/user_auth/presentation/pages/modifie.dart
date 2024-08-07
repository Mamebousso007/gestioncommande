import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/accueil.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produit.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produits.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Modifier extends StatefulWidget {
  final Produit product;
   Modifier({required this.product});

  @override
  State<Modifier> createState() => _ModifierState();
}

class _ModifierState extends State<Modifier> {
  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController descProduitController = TextEditingController();
  final TextEditingController prixVenteController = TextEditingController();
  final TextEditingController stockProduitController = TextEditingController();
  final TextEditingController remiseProduitController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Pré-remplissez les champs d'édition avec les détails du produit
    nomProduitController.text = widget.product.nom;
    descProduitController.text = widget.product.description;
    prixVenteController.text = widget.product.prixvente.toString();
    stockProduitController.text=widget.product.stock.toString();
    remiseProduitController.text=widget.product.remise.toString();
    imageController.text=widget.product.image;
    // ... Pré-remplissez les autres champs
  }



  String? selectedProductID; // ID du produit à modifier.
  String? selectedCategory;
  String? selectedSize;
  String? imageUrl;

  List<String> categories = ['Hommes', 'Femmes', 'Couple'];
  List<String> sizes = ["S", "M", "L", "XL"];
  void updateProduct() async {
    // Récupérez les valeurs des contrôleurs et mettez à jour le produit
    final updatedProduct = Produit(
      id: widget.product.id,
      nom: nomProduitController.text,
      description: descProduitController.text,
      prixvente: num.parse(prixVenteController.text),
      stock: num.parse(stockProduitController.text),
      remise: num.parse(remiseProduitController.text),
      image: imageUrl ?? '', // Utilisez l'URL de l'image existante ou une nouvelle si une nouvelle image a été sélectionnée
      categorie: selectedCategory ?? '', // Utilisez la catégorie sélectionnée
      taille: selectedSize ?? '', // Utilisez la taille sélectionnée
      // ... Mettez à jour les autres propriétés
    );

    print(widget.product.id);

    if (imageUrl != null && imageUrl != widget.product.image) {
      // Si une nouvelle image a été sélectionnée, mettez à jour l'URL de l'image du produit
      updatedProduct.image = imageUrl!;
    }

    FirebaseFirestore.instance.collection('Produits').doc(updatedProduct.id).update({
      'nom': updatedProduct.nom,
      'description': updatedProduct.description,
      'prixvente': updatedProduct.prixvente,
      'stock': updatedProduct.stock,
      'remise': updatedProduct.remise,
      'image': updatedProduct.image,
      'categorie': updatedProduct.categorie,
      'taille': updatedProduct.taille,
      // ... Mettez à jour les autres propriétés
    })
        .then((value) {
      print("Produit mis à jour avec succès !");
      // Vous pouvez également naviguer vers la page de liste de produits après la mise à jour.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Accueil(),
      ));
    })
        .catchError((error) {
      print("Erreur lors de la mise à jour du produit : $error");
    });
  }


  Future<void> changeProductImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String newImagePath = pickedFile.path;
      String? newImageUrl = await uploadImage(newImagePath);

      if (newImageUrl != null) {
        setState(() {
          imageUrl = newImageUrl; // Mettez à jour l'URL de l'image du produit
        });
      } else {
        print('L\'URL de la nouvelle image est nulle.');
      }
    }
  }



  Future<String?> uploadImage(String imagePath) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageReference.putFile(File(imagePath));

      await uploadTask.whenComplete(() => print('Image téléchargée avec succès'));
      String? imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Text("Modifier Produits",
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
                controller: nomProduitController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nom produit',
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
                controller: descProduitController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description produit',
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
                controller: prixVenteController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Prix vente ',
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
              child: DropdownButtonFormField<String>(
                hint: Text('Choisir une taille'),
                value: selectedSize, // Valeur sélectionnée
                onChanged: (newValue) {
                  setState(() {
                    selectedSize = newValue; // Mise à jour avec la nouvelle valeur
                  });
                },
                items: sizes.map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10), // Espacement du texte à gauche
                ),
              ),
            ),

            SizedBox(
              height: 20,
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
                controller: stockProduitController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Stock produit ',
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
                controller: remiseProduitController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA3554E4E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Remise produit ',
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
              child: DropdownButtonFormField<String>(
                hint: Text('Choisir une categorie'),
                value: selectedCategory, // Valeur sélectionnée
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue; // Mise à jour avec la nouvelle valeur
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10), // Espacement du texte à gauche
                ),
              ),
            ),

            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                changeProductImage(); // Appeler la fonction pour changer l'image
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFEC729C), // Changer la couleur de fond
                minimumSize: Size(300, 50), // Définir la hauteur du bouton
              ),
              child: Text(
                'Télécharger une image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),


            SizedBox(
              height: 30,
            ),
            /*ElevatedButton(

              onPressed: () {
                String nomProduit = nomProduitController.text;
                String descProduit = descProduitController.text;
                String prixText = prixVenteController.text;
                //String taille = tailleController.text;
                String size = selectedSize ?? "";
                String stockText = stockProduitController.text;
                String remiseText = remiseProduitController.text;
                String categorie = selectedCategory ?? "";
                print(selectedSize);
                if (prixText.isNotEmpty && stockText.isNotEmpty) {
                  try {
                    double prixVente = double.parse(prixText);
                    int stockProduit = int.parse(stockText);
                    double remiseProduit = double.parse(remiseText);
                    ajouterProduit(
                      nomProduit,
                      descProduit,
                      prixVente,
                      size,
                      stockProduit,
                      remiseProduit,
                      categorie,
                      imageUrl!,
                    );
                  } catch (e) {
                    print("Erreur de conversion : $e");
                  }
                } else {
                  print("Les champs de prix et de stock ne peuvent pas être vides.");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Changer la couleur de fond
                minimumSize: Size(15, 50), // Définir la hauteur du bouton
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
            ),*/
            ElevatedButton(
              onPressed: () {
                // Appelez la fonction pour mettre à jour le produit existant
                updateProduct();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Changer la couleur de fond
                minimumSize: Size(15, 50), // Définir la hauteur du bouton
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
