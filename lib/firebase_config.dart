import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        projectId: 'react-native-firebase-testing',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        messagingSenderId: '448618578101',
        appId: '1:448618578101:web:772d484dc9eb15e9ac3efc',
        measurementId: 'G-0N1G9FLDZE',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:977478755508:ios:d52dc83bf24c318faaa3e1',
        apiKey: 'AIzaSyAOATCzkG1EbzNcAU0f_otgZBuwnhhkBog',
        projectId: 'beanjuice-aa33c',
        messagingSenderId: '977478755508',
        iosBundleId: 'com.firestoretesting.firestoreTesting',
        iosClientId:
        '977478755508-o7ic2i0sfvjr7548jhoq865ia14nt8mc.apps.googleusercontent.com',
        androidClientId:
        '977478755508-2cggk283ot58ki93kg829n59mml90gd6.apps.googleusercontent.com',
        storageBucket: 'beanjuice-aa33c.appspot.com',
        databaseURL: 'https://beanjuice-aa33c-default-rtdb.firebaseio.com',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:977478755508:android:332c8b9c0c221474aaa3e1',
        apiKey: 'AIzaSyDweld6Nt1GkwwPqC93UUlOCbC61pDjXd4', //This is updated
        projectId: 'beanjuice-aa33c',
        messagingSenderId: '977478755508',
      );
    }
  }
}