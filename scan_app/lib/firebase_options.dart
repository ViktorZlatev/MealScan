
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';  // Import this for kIsWeb and defaultTargetPlatform

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web-specific configuration
      return const FirebaseOptions(

           apiKey: "AIzaSyA8Jg-4aGgh3zr6bXsrZEFnKq5yRYvKmCs",
           authDomain: "mealscan-b7705.firebaseapp.com",
           databaseURL: "https://mealscan-b7705-default-rtdb.europe-west1.firebasedatabase.app",
           projectId: "mealscan-b7705",
           storageBucket: "mealscan-b7705.firebasestorage.app",
           messagingSenderId: "768124657000",
           appId: "1:768124657000:web:03e2de0ec4e765cc394add",
           measurementId: "G-M4NQRZWNTW"

      );

    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android-specific configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyCltLR7-kpf1992c8NpwUwrU7Beo5JewKg',
        appId: '1:768124657000:android:0329d616e27ef948394add',
        messagingSenderId: '768124657000',
        projectId: 'mealscan-b7705',
        storageBucket: 'mealscan-b7705.firebasestorage.app',

      );
    }
    throw UnsupportedError('Platform not supported');
  }
}
