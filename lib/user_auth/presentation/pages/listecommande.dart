import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'commande.dart';
import 'detailCommandePage.dart';

class Listecommandes extends StatefulWidget {
  const Listecommandes({Key? key}) : super(key: key);

  @override
  _ListecommandesState createState() => _ListecommandesState();
}

class _ListecommandesState extends State<Listecommandes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Commande>> _recupererCommandes() async {
    try {
      var snapshot = await _firestore.collection('commandes').get();
      return snapshot.docs.map((doc) => Commande.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print("Erreur lors de la récupération des commandes: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFBB9B9)),
        title: Text("Gestion des Commandes"),
      ),
      body: FutureBuilder<List<Commande>>(
        future: _recupererCommandes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune commande trouvée."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Commande commande = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.assignment_turned_in, color: Colors.green),
                  title: Text("Commande ${commande.id}", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${commande.date.toLocal()}"),
                      Text("Total: ${commande.montantTotal} FCFA", style: TextStyle(color: Color(0xFFFBB9B9))),
                      // Ajoutez ici d'autres informations pertinentes
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailCommandePage(commande: commande),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.local_shipping, color: Colors.orange),
                        onPressed: () {

                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
