import 'dart:convert';

import 'package:barterit/screens/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/items.dart';
import '../models/process.dart';
import '../models/user.dart';
import '../myConfig.dart';

class UserBarterItem extends StatefulWidget {
  final User buyerUser;
  final Item sellerItem;
  const UserBarterItem(
      {super.key, required this.sellerItem, required this.buyerUser});

  @override
  State<UserBarterItem> createState() => _UserBarterItemState();
}

class _UserBarterItemState extends State<UserBarterItem> {
  late double screenH, screenW;
  List<Item> itemsList = <Item>[];
  String mainTitle = "User's Items List";
  int axisCount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int selectedIndex =
      -1; // Initialize with -1 to indicate no item is selected initially
  Item buyerItems = Item();
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
                      return Card(
                        color: selectedIndex == index
                            ? const Color.fromARGB(255, 190, 225, 191)
                            : Colors.white,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              buyerItems =
                                  Item.fromJson(itemsList[index].toJson());
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              selectedIndex = -1;
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100,
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
                            ],
                          ),
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
        onPressed: () {
          if (selectedIndex == -1) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select an item")));
            return;
          }

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text(
                    "Terms And Conditions",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman"),
                  ),
                  content: SizedBox(
                    height: 1 / 2 * screenH,
                    width: screenW,
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("There are 4 terms:",
                              style: TextStyle(
                                  fontFamily: "Times New Roman",
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "1. By continuing this action it may hold RM 3.00 from your credit.",
                              style: TextStyle(fontFamily: "Times New Roman")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "2. You need to wait for the other side confirmation (if they reject your request, your RM 3.00 credit will be given back).",
                              style: TextStyle(fontFamily: "Times New Roman")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "3. Once you confirm to barter the item, RM 1.00 will be deduct from your hold credit and the remaining RM 2.00 will be automatically added back to your credit",
                              style: TextStyle(fontFamily: "Times New Roman")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "4. Once you cancel to barter the item, RM 3.00 will be deduct from your hold credit ",
                              style: TextStyle(fontFamily: "Times New Roman")),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: GestureDetector(
                          onTap: null,
                          child: const Text(
                            "I Agree With The Terms",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              insertProcess();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.green),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  loadUserItems(int page) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
        body: {
          "userid": widget.buyerUser.id,
          "pageno": page.toString()
        }).then((response) {
      itemsList.clear();

      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            var extractData = jsondata['data'];
            extractData['items'].forEach((v) {
              itemsList.add(Item.fromJson(v));
            });
          }
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
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

  void insertProcess() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/insert_process.php"),
        body: {
          "buyerUserId": widget.buyerUser.id.toString(),
          "sellerUserId": widget.sellerItem.userId.toString(),
          "buyerItem": buyerItems.itemId.toString(),
          "sellerItem": widget.sellerItem.itemId.toString(),
        }).then((response) async {
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            Process process = Process.fromJson(jsondata['data']);
            holdCredit(process);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Process Failed")));
          }
          Navigator.pop(context);
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void holdCredit(Process processI) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_credit.php"),
        body: {
          "buyerid": widget.buyerUser.id.toString(),
          "sellerId": widget.sellerItem.userId.toString(),
          "processStatus": processI.status.toString(),
        }).then((response) async {
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Process successful, please wait for the other side confirmation")));
            await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: widget.buyerUser,
                        )));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Process Failed")));
          }
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }
}
