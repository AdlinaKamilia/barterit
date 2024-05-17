import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barterit/screens/contactItemS.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/process.dart';
import '../models/user.dart';
import '../myConfig.dart';

class BarterProcessScreen extends StatefulWidget {
  final User user;
  const BarterProcessScreen({super.key, required this.user});

  @override
  State<BarterProcessScreen> createState() => _BarterProcessScreenState();
}

class _BarterProcessScreenState extends State<BarterProcessScreen> {
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
        title: const Text("Buyer Barter Process"),
      ),
      body: Container(
        child: processList.isEmpty
            ? const Center(
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
                                    builder: (content) => ContactItemS(
                                        processItem: process,
                                        user: widget.user),
                                  ),
                                );
                                loadAllProcess();
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: CachedNetworkImage(
                                      width: screenWidth,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${MyConfig().server}/barterit/assets/items/${processList[index].sellerItemId}_1.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(
                                    " ${processList[index].sellerItemName.toString()}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                      "RM ${processList[index].sellerItemPrice.toString()}"),
                                  Text(
                                      "${processList[index].sellerItemQty.toString()} available"),
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
        "buyer_id": widget.user.id.toString(),
        "processStatus": "Confirm",
      },
    ).then((response) {
      processList.clear();
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response
              .body); // Replace 'data' with your JSON string or data source
          // Continue processing the parsed JSON data
          print(response.body);
          if (jsondata['status'] == "success") {
            var extractdata = jsondata['data'];
            extractdata['process'].forEach((v) {
              processList.add(Process.fromJson(v));
            });
          }
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      }
      setState(() {});
    });
  }
}
