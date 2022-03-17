import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Profile'),
    );
  }
}

