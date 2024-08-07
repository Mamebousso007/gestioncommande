import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/accueil.dart';
import 'package:gestioncommande/user_auth/presentation/pages/ajoutprod.dart';
import 'package:gestioncommande/user_auth/presentation/pages/login.dart';
import 'package:gestioncommande/user_auth/presentation/pages/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCvm4wIQxuhBcK4jL-bE60vScTcU8hfP90",
      authDomain: "gestion-commande2.firebaseapp.com",
      projectId: "gestion-commande2",
      storageBucket: "gestion-commande2.appspot.com",
      messagingSenderId: "115080539774",
      appId: "1:115080539774:web:4137928e55dcaa5ec8f22f"
    ),
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Commande',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Définissez ici le thème de votre application
      ),
      home: Connexion(), // Page d'accueil de votre application
    );
  }
}
