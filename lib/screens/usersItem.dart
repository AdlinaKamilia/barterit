import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:barterit/screens/newItemScreen.dart';
import 'package:barterit/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../myConfig.dart';
import 'itemDetailScreen.dart';

class UserItemScreen extends StatefulWidget {
  final User user;
  const UserItemScreen({super.key, required this.user});

  @override
  State<UserItemScreen> createState() => _UserItemScreenState();
}

class _UserItemScreenState extends State<UserItemScreen> {
  late double screenH, screenW;
  List<Item> itemsList = <Item>[];
  String mainTitle = "User's Items List";
  int axisCount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  @override
  void initState() {
    super.initState();
    loadUserItems(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mainTitle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: itemsList.isEmpty
            ? const Center(
                child: Text("No Items Registered"),
              )
            : Column(
                children: [
                  Text(
                    "Total Number of Users Item : ${itemsList.length} ",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman"),
                  ),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: axisCount,
                    children: List.generate(itemsList.length, (index) {
                      print(itemsList[index].itemId);
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Item items =
                                Item.fromJson(itemsList[index].toJson());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => ItemDetail(
                                        user: widget.user, item: items)));
                            loadUserItems(1);
                          },
                          child: Column(children: [
                            SizedBox(
                              height: 130,
                              child: CachedNetworkImage(
                                width: screenW,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().server}/barterit/assets/items/${itemsList[index].itemId}_1.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Text(
                              itemsList[index].itemName.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              "RM ${double.parse(itemsList[index].itemPrice.toString()).toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "${itemsList[index].itemQuantity} available",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ]),
                        ),
                      );
                    }),
                  )),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        //build the list for textbutton with scroll
                        if ((curpage - 1) == index) {
                          //set current page number active
                          color = Colors.blue;
                        } else {
                          color = Colors.black;
                        }
                        return TextButton(
                            onPressed: () {
                              curpage = index + 1;
                              loadUserItems(index + 1);
                            },
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color, fontSize: 15),
                            ));
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () async {
          if (widget.user.id != "na") {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => NewItemScreen(user: widget.user)));
            loadUserItems(1);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    title: const Text(
                      "Please Login/ Register An Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content:
                        const Text("You need an account to access this page"),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => const LoginScreen()));
                          },
                          child: const Text("Login")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) =>
                                        const RegisterScreen()));
                          },
                          child: const Text("Register")),
                    ],
                  );
                });
          }
        },
        child: const Text("+", style: TextStyle(fontSize: 38)),
      ),
    );
  }

  loadUserItems(int page) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      itemsList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractData = jsondata['data'];
          extractData['items'].forEach((v) {
            itemsList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  Future<void> _refreshData() async {
    // Simulate a delay for fetching new data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loadUserItems(1);
    });
  }
}
