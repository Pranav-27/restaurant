//initialize restaurant data from JSON
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/models/food_entity.dart';
import 'package:restaurant/views/cart/CartPage.dart';

import '../views/home/HomePage.dart';
import '../views/home/HomePage.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static Widget myDrawer(User user, String userName, BuildContext context, List<FoodEntity> checkoutFoods) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Cart"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(foods: checkoutFoods)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Search"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Sign Out"),
            onTap: () {
              signOut();
            },
          ),
          
        ],
      ),
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static showSnackBar(String? text) {
    if (text == null) {
      return;
    }

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<String> getUserName(User user) async {
    final ref = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await ref.doc(user.uid).get();
    var data = snapshot.data() as Map;
    return data["name"];
  }

}
