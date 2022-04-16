import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'globals.dart' as globals;

final coffeeRef =
FirebaseFirestore.instance.collection('coffee').withConverter<Coffee>(
  fromFirestore: (snapshots, _) => Coffee.fromJson(snapshots.data()!),
  toFirestore: (coffee, _) => coffee.toJson(),
);

class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}

/// The different ways that we can filter/sort coffees.
enum CoffeeQuery {
  rating,
}

extension on Query<Coffee> {
  /// Create a firebase query from a [CoffeeQuery]
  Query<Coffee> queryBy(CoffeeQuery query) {
    switch (query) {
      case CoffeeQuery.rating:
        return orderBy('rating', descending: true);
    }
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  CoffeeQuery query = CoffeeQuery.rating;

  ///Was my test list for searchbar widget
  // static List<Person> people = [
  //   Person('Mike', 'Barron', 64),
  //   Person('Todd', 'Black', 30),
  //   Person('Ahmad', 'Edwards', 55),
  //   Person('Anthony', 'Johnson', 67),
  //   Person('Annette', 'Brooks', 39),
  // ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text('BeanJuice'),
            foregroundColor: Colors.orange[900],
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
            ],
            bottom: AppBar(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                  top: Radius.circular(15),
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepOrange,
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: Center(
                  child: Container(),
                  // child: TextField(
                  //   showCursor: false,
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                  //       hintText: 'Search for something',
                  //       prefixIcon: Icon(Icons.search)),
                  //   onTap: () => showSearch(
                  //     context: context,
                  //     delegate: SearchPage<Coffee>(
                  //       onQueryUpdate: (s) => print(s),
                  //       items: coffeeList,
                  //       searchLabel: 'Search people',
                  //       barTheme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.deepOrange)),
                  //       suggestion: Center(
                  //         child: Text('Filter people by name, surname or age'),
                  //       ),
                  //       failure: Center(
                  //         child: Text('No person found :('),
                  //       ),
                  //       filter: (coffee) => [
                  //         // person.name,
                  //         // person.surname,
                  //         // person.age.toString(),
                  //         coffee.roast,
                  //         coffee.name,
                  //         coffee.brand,
                  //       ],
                  //       builder: (coffee) => ListTile(
                  //         title: Text(coffee.name),
                  //         subtitle: Text(coffee.brand),
                  //         trailing: Text('${coffee.roast}'),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ),
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return StreamBuilder<QuerySnapshot<Coffee>>(
                  stream: coffeeRef.queryBy(query).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.requireData;

                    return Container(
                      child: _CoffeeItem(
                        data.docs[index].data(),
                        data.docs[index].reference,
                      ),
                    );
                  },
                );
              },
              childCount: 6,
            ),
          ),
        ]
      ),
    );
  }
}
/// A single coffee row.
class _CoffeeItem extends StatelessWidget {
  _CoffeeItem(this.coffee, this.reference);

  final Coffee coffee;
  final DocumentReference<Coffee> reference;

  /// Returns the coffee photo.
  Widget get photo {
    return SizedBox(
      width: 100,
      child: Image.network(coffee.photo),
    );
  }

  /// Returns coffee details.
  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          metadata,
          roasts,
        ],
      ),
    );
  }

  /// Return the brand name.
  Widget get name {
    return Text(
      '${coffee.name}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Returns metadata about the coffee.
  Widget get metadata {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${coffee.brand} - ${coffee.roast}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text('Rating: ${coffee.rating}'),
          ),
        ],
      ),
    );
  }

  /// Returns all roasts.
  Widget get roasts {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        // children: roastItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          photo,
          Flexible(child: details),
        ],
      ),
    );
  }
}

@immutable
class Coffee {
  Coffee({
    required this.roast,
    required this.photo,
    required this.brand,
    required this.name,
    required this.rating,
  });

  Coffee.fromJson(Map<String, Object?> json)
      : this(
    roast: json['roast']! as String,
    photo: json['photo']! as String,
    brand: json['brand']! as String,
    name: json['name']! as String,
    rating: json['rating']! as double,
  );

  final String photo;
  final String name;
  final double rating;
  final String brand;
  final String roast;

  Map<String, Object?> toJson() {
    return {
      'roast': roast,
      'photo': photo,
      'brand': brand,
      'name': name,
      'rating': rating,
    };
  }

}
