import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/process.dart';
import '../models/user.dart';
import '../myConfig.dart';
import 'contactItemB.dart';

class BarterSellerScreen extends StatefulWidget {
  final User user;
  const BarterSellerScreen({super.key, required this.user});

  @override
  State<BarterSellerScreen> createState() => _BarterSellerScreenState();
}

class _BarterSellerScreenState extends State<BarterSellerScreen> {
  List<Process> processList = <Process>[];
  late double screenHeight, screenWidth;
  int axisCount = 2;

  @override
  void initState() {
    super.initState();
    loadAllProcess();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Barter Process"),
      ),
      body: Container(
        child: processList.isEmpty
            ? Center(
                child: Text("No Items Registered"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Total Number of Item : ${processList.length} ",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(
                      height: screenHeight *
                          0.8, // Set a specific height for the GridView
                      child: GridView.count(
                        crossAxisCount: axisCount,
                        children: List.generate(processList.length, (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Process process = Process.fromJson(
                                    processList[index].toJson());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => ContactItemB(
                                        processItem: process,
                                        user: widget.user),
                                  ),
                                );
                                loadAllProcess();
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 1 / 5 * screenHeight,
                                    child: CachedNetworkImage(
                                      width: screenWidth,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${MyConfig().server}/barterit/assets/items/${processList[index].buyerItemId}_1.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(
                                    " ${processList[index].buyerItemName.toString()}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                      "RM ${processList[index].buyerItemPrice.toString()}"),
                                  Text(
                                      "${processList[index].buyerItemQty.toString()} available"),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void loadAllProcess() {
    http.post(
      Uri.parse("${MyConfig().server}/barterit/php/load_process.php"),
      body: {
        "seller_id": widget.user.id.toString(),
        "processStatus": "Confirm",
      },
    ).then((response) {
      processList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['process'].forEach((v) {
            processList.add(Process.fromJson(v));
          });
        }
      }
      setState(() {});
    });
  }
}
