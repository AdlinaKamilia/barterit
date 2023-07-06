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
import 'itemDetailScreen.dart';

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
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  int totalresult = 0;
  final TextEditingController _searchEditingC = TextEditingController();
  var color;
  @override
  void initState() {
    super.initState();
    loadAllItems(1);
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
        actions: [
          IconButton(
              onPressed: () {
                showSearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
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
                          onTap: () {
                            Item items =
                                Item.fromJson(itemsList[index].toJson());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => ItemDetail(
                                        user: widget.user, item: items)));
                            loadAllItems(1);
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
                              loadAllItems(index + 1);
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
    );
  }

  goToUserItemScreen() async {
    if (widget.user.id != "na") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => UserItemScreen(user: widget.user)));
      await loadAllItems(1);
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

  loadAllItems(int page) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
        body: {"pageno": page.toString()}).then((response) {
      itemsList.clear();
      totalresult = 0;
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemsList.add(Item.fromJson(v));
            totalresult = totalresult + 1;
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
      loadAllItems(1);
    });
  }

  void showSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side:
                    BorderSide(color: Theme.of(context).colorScheme.secondary)),
            title: const Text(
              "Enter item to be search:",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchEditingC,
                  decoration: const InputDecoration(
                      labelText: "Search",
                      labelStyle: TextStyle(),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(width: 2))),
                ),
                const SizedBox(
                  height: 4,
                ),
                ElevatedButton(
                    onPressed: () {
                      String search = _searchEditingC.text;
                      searchItems(search);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Search"))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(),
                  ))
            ],
          );
        });
  }

  void searchItems(String search) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
        body: {
          "search": search,
        }).then((response) {
      itemsList.clear();
      totalresult = 0;
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);

          var extractData = jsondata['data'];
          extractData['items'].forEach((v) {
            itemsList.add(Item.fromJson(v));
            totalresult = totalresult + 1;
          });
        }
        setState(() {});
      }
    });
  }
}
