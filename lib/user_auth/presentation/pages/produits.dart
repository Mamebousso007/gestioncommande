import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:remixicon/remixicon.dart';

import 'ajoutprod.dart';
import 'details.dart';
import 'modifie.dart';

class Produits extends StatefulWidget {
  const Produits({Key? key}) : super(key: key);

  @override
  State<Produits> createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {

  Future<void> deleteProductImage(String imageUrl) async {
    try {
      if (imageUrl != null) {
        final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await imageRef.delete();
        print('Image du produit supprimée avec succès');
      } else {
        print('L\'URL de l\'image est nulle.');
      }
    } catch (e) {
      print('Erreur lors de la suppression de l\'image : $e');
    }
  }

  Future<void> deleteProduct(String productId, String imageUrl) async {
    try {
      // Supprimez d'abord l'image du produit
      await deleteProductImage(imageUrl);

      // Ensuite, supprimez le produit de la base de données
      await FirebaseFirestore.instance.collection('Produits').doc(productId).delete();
      print('Produit supprimé avec succès');
    } catch (e) {
      print('Erreur lors de la suppression du produit : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Text("Produits",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjouterProduit(),
            ),
          );
        },
        backgroundColor: Colors.blue, // Couleur WhatsApp
        child: Icon(Remix.add_circle_fill), // Image WhatsApp
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            children: [

              /*Container(
                width: 149,
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 38),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFF49D726),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AjouterProduit()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ajouter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              SizedBox(height: 20,),
              Expanded(
                  child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  // Texte principal avec ombre
                                  Text(
                                    'Liste Produits',
                                    style: TextStyle(
                                      color: Color(0x75FF18BE), // Couleur principale
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('Produits').snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {

                                  return CircularProgressIndicator();
                                }

                                final produits = snapshot.data!.docs.map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;

                                  final id = data['id'] as String?;
                                  final nom = data['nom'] as String?;
                                  final description = data['description'] as String?;
                                  final prixvente = (data['prixvente'] ?? 0.0) as num;
                                  final image = data['image'] as String?;
                                  final categorie = data['categorie'] as String?;
                                  final stock = (data['stock'] ?? 0) as num;
                                  final remise = (data['remise'] ?? 0.0) as num;
                                  final taille = data['taille'] as String?;

                                  return Produit(
                                    id: id ?? '',
                                    nom: nom ?? '',
                                    description: description ?? '',
                                    prixvente: prixvente,
                                    image: image ?? '',
                                    categorie: categorie ?? '',
                                    stock: stock,
                                    remise: remise,
                                    taille: taille ?? '',
                                  );
                                }).toList();

                                return Container(
                                    height: MediaQuery.of(context).size.height,
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (BuildContext context, int index) {
                                            final produit = produits[index];
                                            return Card(
                                              child: ListTile(
                                                leading: Image.network(
                                                  produit.image,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                                title: Text(produit.nom),
                                                subtitle: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => Details(produit: produit),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Prix : ${produit.prixvente} FCFA'),
                                                        Text("Details"),
                                                        Icon(Icons.arrow_forward)
                                                      ]

                                                  ),
                                                ),
                                                trailing: SizedBox(
                                                  width: 60,
                                                  child: Row(

                                                    children: [
                                                            InkWell(
                                                              child: Icon(Icons.edit, color: Colors.lightBlue.withOpacity(0.75),),
                                                              onTap: () {
                                                                final selectedProduct = produits[index];
                                                                Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                    builder: (context) => Modifier(
                                                                      product: selectedProduct, // Utilisez les détails du produit
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                      InkWell(
                                                        child: Icon(Icons.delete, color: Colors.red.withOpacity(0.75)),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              print(produit.id);
                                                              return AlertDialog(
                                                                title: Text("Confirmation de la suppression"),
                                                                content: Text("Voulez-vous vraiment supprimer ce produit ?"),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text("Annuler"),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),

                                                                  TextButton(
                                                                    child: Text("Supprimer"),
                                                                    onPressed: () {
                                                                      deleteProduct(produit.id, produit.image);
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),

                                                    ],
                                                  ),
                                                ), // Icône "détails"


                                              ),
                                            );
                                          },
                                          childCount: produits.length, // Nombre total d'éléments dans la liste
                                        ),
                                      ),
                                    ],
                                  )

                                )
                                ;
                              },
                            ),
                          )
                        ],
                  )
              )
            ]

        ),
      ),
    );
  }
}
