import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gestioncommande/user_auth/presentation/pages/users.dart';
import 'package:remixicon/remixicon.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {

// Méthode pour obtenir tous les utilisateurs (sans filtrer par rôle)
  Future<List<Users>> getClients() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs.map((doc) => Users.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des clients: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Text("Client",
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Liste des clients",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0x75FF18BE), // Vous pouvez ajuster la couleur selon votre thème
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Users>>(
                future: getClients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Erreur: ${snapshot.error}");
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Users user = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Icon(Remix.user_3_line, size: 30),
                            title: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: ${user.email}"),
                                Text("Téléphone: ${user.telephone}"),
                                Text("Adresse: ${user.adresse}"),

                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Aucun client trouvé"));
                  }
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
