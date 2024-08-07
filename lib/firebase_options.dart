// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvm4wIQxuhBcK4jL-bE60vScTcU8hfP90',
    appId: '1:115080539774:web:9148aad71b20fa42c8f22f',
    messagingSenderId: '115080539774',
    projectId: 'gestion-commande2',
    authDomain: 'gestion-commande2.firebaseapp.com',
    storageBucket: 'gestion-commande2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE_GSx5kAtiFZAbwQYKVH74HMhbtJ9EzQ',
    appId: '1:115080539774:android:c28323cff5134844c8f22f',
    messagingSenderId: '115080539774',
    projectId: 'gestion-commande2',
    storageBucket: 'gestion-commande2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuJGs9l-zOgUfz_mJFaVvkUJzRI04ZMIg',
    appId: '1:115080539774:ios:4cd4be15e18d498cc8f22f',
    messagingSenderId: '115080539774',
    projectId: 'gestion-commande2',
    storageBucket: 'gestion-commande2.appspot.com',
    iosBundleId: 'com.example.gestioncommande',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuJGs9l-zOgUfz_mJFaVvkUJzRI04ZMIg',
    appId: '1:115080539774:ios:7a01760226b8bf36c8f22f',
    messagingSenderId: '115080539774',
    projectId: 'gestion-commande2',
    storageBucket: 'gestion-commande2.appspot.com',
    iosBundleId: 'com.example.gestioncommande.RunnerTests',
  );
}
