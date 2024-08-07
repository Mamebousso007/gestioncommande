import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/listecli.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produit.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produits.dart';
import 'package:remixicon/remixicon.dart';

import 'ajoutprod.dart';
import 'collections.dart';
import 'details.dart';
import 'listecommande.dart';
import 'login.dart';
import 'modifie.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  @override
  void initState() {
    super.initState();

    // Demande de permission pour iOS
    requestPermission();

    // Écoute des messages FCM lorsque l'application est en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Gérer le message reçu
      print("Message: ${message.notification?.body}");
      // Vous pouvez ici afficher une alerte, un SnackBar, etc.
    });

    // Gestion des messages en arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Récupération et traitement du token FCM
    setupFCMToken();
  }

  void requestPermission() async {
    // Demande de permission pour iOS (pas nécessaire pour Android)
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    print('User permission status: ${settings.authorizationStatus}');
  }

  void setupFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': token});


  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // Gérer le message reçu en arrière-plan
  }

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
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
          IconButton(
              icon: Icon(
                Remix.menu_2_fill,
                color: Color(0xFFFBB9B9),
              ),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        //widget.apiRequest!.allitems![0].logo!??""
        title: Text("Accueil",
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
       // backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        elevation: 0,
        backgroundColor: Color(0xFFF3F3F3),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [


            Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: ListTile(
                      leading: Icon(Remix.file_list_2_line,
                          size: 25, color: Colors.black),
                      title: Text(
                        "Liste Commandes",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Color(0xFFEC729C),
                        size: 14,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {

                    },
                    child: ListTile(
                      leading: Icon(Remix.notification_2_line,
                          size: 25, color: Colors.black),
                      title: Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Color(0xFFEC729C),
                        size: 14,
                      ),
                    ),
                  ),


                  Container(
                    width: 280,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFC6C6C6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: ListTile(
                      leading: Icon(Remix.settings_2_fill,
                          size: 25, color: Colors.black),
                      title: Text(
                        "Parametres",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Color(0xFFEC729C),
                        size: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Connexion()));
                    },
                    child: ListTile(
                      leading: Icon(Remix.login_box_line,
                          size: 25, color: Colors.black),
                      title: Text(
                        "Se déconnecter",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Color(0xFFEC729C),
                        size: 14,
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(

                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                //color: Colors.grey.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF7FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 15.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.view_comfy, // Utilisez l'icône "box" pour la gestion des produits
                                  size: 35,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Collections(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Collections",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 8,
                    ),

                    Container(
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF7FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 15.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Clients(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              const Text(
                                "CLients",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),

                    Container(
                      padding: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF7FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 15.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                          )
                        ],
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.receipt_long, // Utilisez l'icône "shopping_bag" pour la gestion des commandes
                                  size: 35,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Listecommandes(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Commandes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
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
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    // Texte principal avec ombre
                    Text(
                      'Articles récents',
                      style: TextStyle(
                        color: Color(0xFFFBB9B9), // Couleur principale
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),


                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),

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

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Important pour éviter les conflits de défilement
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: produits.length,
                    itemBuilder: (context, index) {
                      final produit = produits[index];
                      return Card(
                        child: InkWell(
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
                              Expanded(
                                child: Image.network(
                                  produit.image,
                                  width: double.infinity, // Prend toute la largeur disponible
                                  fit: BoxFit.cover, // Remplit l'espace tout en conservant les proportions
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      produit.nom,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis, // Ajoute des points de suspension si le texte est trop long
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Prix : ${produit.prixvente} FCFA',
                                      style: TextStyle(
                                        color: Color(0xFFFBB9B9),
                                        fontSize: 14,
                                      ),
                                    ),
                                    // Ajouter d'autres informations sur le produit si nécessaire
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );


                },
              ),
            )

          ]



        ),

    );
  }
}
