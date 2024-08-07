import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AjouterProduit extends StatefulWidget {
  const AjouterProduit({Key? key}) : super(key: key);

  @override
  State<AjouterProduit> createState() => _AjouterProduitState();
}

class _AjouterProduitState extends State<AjouterProduit> {
  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController descProduitController = TextEditingController();
  final TextEditingController prixVenteController = TextEditingController();
  //final TextEditingController tailleController = TextEditingController();
  final TextEditingController stockProduitController = TextEditingController();
  final TextEditingController remiseProduitController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  String? selectedCategory;
  String? imageUrl;
  String? selectedSize;

  // Liste statique de catégories prédéfinies
  List<String> categories = ['Hommes', 'Femmes', 'Enfants'];
  List<String> sizes = ["S", "M", "L", "XL", "XXL"];
  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImageAndAddProduct(String nomProduit, String descProduit, double prixVente, String taille, int stockProduit, double remiseProduit, String categorie) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String imagePath = pickedFile.path;
        String? imageUrl = await uploadImage(imagePath);

        if (imageUrl != null) {
          ajouterProduit(nomProduit, descProduit, prixVente, taille, stockProduit, remiseProduit, categorie, imageUrl);
        } else {
          print('L\'URL de l\'image est nulle.');
        }
      } else {
        print('Aucune image sélectionnée.');
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image : $e');
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

 /* void ajouterProduit(String nomProduit, String descProduit, double prixVente, String taille, int stockProduit, double remiseProduit, String categorie, String? imageUrl) {
    FirebaseFirestore.instance.collection('Produits').add({
      'nom': nomProduit,
      'description': descProduit,
      'prixvente': prixVente,
      'taille': taille,
      'stock': stockProduit,
      'remise': remiseProduit,
      'categorie': categorie,
      'image': imageUrl,
    })
        .then((value) {
      print("Produit ajouté avec succès !");
      // Réinitialiser les champs après l'ajout réussi
      nomProduitController.clear();
      descProduitController.clear();
      prixVenteController.clear();
      stockProduitController.clear();
      remiseProduitController.clear();
      imageController.clear();
      selectedCategory = null;
      selectedSize = null;
    })
        .catchError((error) {
      print("Erreur lors de l'ajout du produit : $error");
    });
  }
*/

  void ajouterProduit(String nomProduit, String descProduit, double prixVente, String taille, int stockProduit, double remiseProduit, String categorie, String? imageUrl) {
    DocumentReference produitReference = FirebaseFirestore.instance.collection('Produits').doc();

    produitReference.set({
      'id': produitReference.id, // Utilisez l'ID auto-généré par Firestore
      'nom': nomProduit,
      'description': descProduit,
      'prixvente': prixVente,
      'taille': taille,
      'stock': stockProduit,
      'remise': remiseProduit,
      'categorie': categorie,
      'image': imageUrl,
    })
        .then((value) {
      print("Produit ajouté avec succès !");
      // Réinitialisez les champs après l'ajout réussi
      nomProduitController.clear();
      descProduitController.clear();
      prixVenteController.clear();
      stockProduitController.clear();
      remiseProduitController.clear();
      imageController.clear();
      selectedCategory = null;
      selectedSize = null;
    })
        .catchError((error) {
      print("Erreur lors de l'ajout du produit : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFBB9B9)),
        title: Text("Ajouter Produits",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            )),
        actions: [
          Image(
            image: AssetImage("images/logo.jpg"),
            height: 40,
            width: 40,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                    side: BorderSide(width: 1, color: Color(0xFFFBB9B9)),
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
                  pickImageAndAddProduct(
                    nomProduitController.text,
                    descProduitController.text,
                    double.parse(prixVenteController.text),
                    selectedSize ?? "",
                    int.parse(stockProduitController.text),
                    double.parse(remiseProduitController.text),
                    selectedCategory ?? "",
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFF68B73), // Changer la couleur de fond
                  minimumSize: Size(300, 50), // InfiniDB la hauteur du bouton
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
              ElevatedButton(
          
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
