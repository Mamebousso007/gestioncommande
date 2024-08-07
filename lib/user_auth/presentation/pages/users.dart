import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String motdpass;
  String email;
  String telephone;
  String username;
  String role;
  String adresse;

  Users({

    required this.motdpass,
    required this.email,
    required this.telephone,
    required this.username,
    required this.role,
    required this.adresse,
  });



  // Factory pour créer une instance à partir d'un DocumentSnapshot
  factory Users.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Users(
      motdpass: data.containsKey('Mot de pass') ? data['Mot de pass'] : '',
      email: data.containsKey('email') ? data['email'] : '',
      telephone: data.containsKey('Telephone') ? data['Telephone'] : '',
      username: data.containsKey('username') ? data['username'] : '',
      role: data.containsKey('role') ? data['role'] : '',
      adresse: data.containsKey('Adresse') ? data['Adresse'] : '',
    );
  }
  Map<String, dynamic> toMap() {
    return {

      'Mot de pass': motdpass,
      'email': email,
      'Telephone': telephone,
      'username': username,
      'role': role,
      'Adresse' : adresse,
    };
  }

  static Future<List<Users>> getClients() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      return querySnapshot.docs.map((doc) => Users.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des clients: $e');
      throw e;
    }
  }
}
