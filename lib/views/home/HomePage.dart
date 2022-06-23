// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:restaurant/models/food_entity.dart';
import 'package:restaurant/services/gsheets_api.dart';
import 'package:restaurant/services/utils.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<FoodEntity>> foods;
  final user = FirebaseAuth.instance.currentUser!;
  String userName = '';
  TextEditingController _countController = TextEditingController();
  List<FoodEntity> orders = [];

  @override
  void initState() {
    super.initState();
    foods = GSheetsAPi.getFoods();
    setUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAE5D3),
      drawer: Utils.myDrawer(user, userName, context, orders),
      appBar: AppBar(
        backgroundColor: const Color(0xff292639),
        title: Text("Home"),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'MENU ITEMS',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            FutureBuilder(
              builder: (BuildContext ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //if there is an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error} occured'),
                    );
                  }

                  //if we got data
                  else if (snapshot.hasData) {
                    final data = snapshot.data as List<FoodEntity>;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      NumberInputWithIncrementDecrement(
                                        controller: _countController,
                                      ),
                                      SizedBox(height: 20.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          addToCart(data[index], int.parse(_countController.text));
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text:
                                                'Added to cart!',
                                            autoCloseDuration:
                                                Duration(seconds: 5),
                                          );
                                        },
                                        child: Text('Add to cart'),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          child: Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                height: 75,
                                width: 75,
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data[index].imageUrl)),
                              ),
                              title: Text(data[index].name),
                              subtitle: Text(data[index].price),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: foods,
            ),
          ],
        ),
      ),
    );
  }

  void setUserName() async {
    String temp = await Utils.getUserName(user);

    setState(() {
      userName = temp;
    });
  }

  Future bottomView(FoodEntity food) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(),
            ],
          );
        });
  }

  void addToCart(FoodEntity food, int count) {
    for(int i = 0; i < count; i++) {
      setState(() {
          orders.add(food);
      });
    }
  }

}
