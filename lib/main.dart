// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testing/screens/profile_screen.dart';
import 'package:firestore_testing/screens/search_screen.dart';
import 'package:firestore_testing/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_testing/firebase_config.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  runApp(FirestoreExampleApp());
}

class FirestoreExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example App',
      theme: ThemeData.light(),
      home: CoffeeList(),
    );
  }
}

class CoffeeList extends StatefulWidget {
  const CoffeeList({Key? key}) : super(key: key);

  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  int _selectedIndex = 0;
  CoffeeQuery query = CoffeeQuery.rating;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: Color.fromARGB(180, 203, 203, 203), blurRadius: 10)
            ]
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange[800],
          onTap: _onItemTapped,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
