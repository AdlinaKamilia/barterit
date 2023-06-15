import 'dart:convert';
import 'package:barterit/screens/usersItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:barterit/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../myConfig.dart';

class ItemListingScreen extends StatefulWidget {
  final User user;
  const ItemListingScreen({super.key, required this.user});

  @override
  State<ItemListingScreen> createState() => _ItemListingScreenState();
}

class _ItemListingScreenState extends State<ItemListingScreen> {
  late double screenH, screenW;
  List<Item> itemsList = <Item>[];
  String mainTitle = "Item List";
  int axisCount = 2;
  @override
  void initState() {
    super.initState();
    loadAllItems();
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
            ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 300,
                      ),
                      ElevatedButton(
                          onPressed: goToUserItemScreen,
                          child: const Text("Users Item")),
                    ],
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("No Items Registered"),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 300,
                      ),
                      ElevatedButton(
                          onPressed: goToUserItemScreen,
                          child: const Text("Users Item")),
                    ],
                  ),
                  Text(
                    "Total Number of Item : ${itemsList.length} ",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman"),
                  ),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: axisCount,
                    children: List.generate(itemsList.length, (index) {
                      return Card(
                        child: InkWell(
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
                  ))
                ],
              ),
      ),
    );
  }

  goToUserItemScreen() async {
    if (widget.user.id != "na") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => UserItemScreen(user: widget.user)));
      await loadAllItems();
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
              content: const Text("You need an account to access this page"),
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
                              builder: (content) => const RegisterScreen()));
                    },
                    child: const Text("Register")),
              ],
            );
          });
    }
  }

  loadAllItems() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
        body: {}).then((response) {
      itemsList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemsList.add(Item.fromJson(v));
          });
        }

        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  Future<void> _refreshData() async {
    // Simulate a delay for fetching new data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loadAllItems();
    });
  }
}
