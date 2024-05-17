import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/process.dart';
import '../models/user.dart';
import '../myConfig.dart';
import 'package:http/http.dart' as http;

import 'mainscreen.dart';

class BarterRequest extends StatefulWidget {
  final User seller;
  const BarterRequest({super.key, required this.seller});

  @override
  State<BarterRequest> createState() => _BarterRequestState();
}

class _BarterRequestState extends State<BarterRequest> {
  List<Process> processList = <Process>[];
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    print(widget.seller.id);
    loadProcess();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barter Request Confirmation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          processList.isEmpty
              ? const Center(
                  child: Text("No request available"),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: processList.length,
                      itemBuilder: (context, index) {
                        print(index);
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          width: screenWidth / 2.5,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "${MyConfig().server}/barterit/assets/items/${processList[index].buyerItemId}_1.png",
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Text(processList[index]
                                            .buyerItemName
                                            .toString())
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.change_circle),
                                  Column(
                                    children: [
                                      CachedNetworkImage(
                                        width: screenWidth / 2.5,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${MyConfig().server}/barterit/assets/items/${processList[index].sellerItemId}_1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      Text(processList[index]
                                          .sellerItemName
                                          .toString())
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        var index1 = index;
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                title: const Text(
                                                  "Terms And Conditions",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          "Times New Roman"),
                                                ),
                                                content: SizedBox(
                                                  height: 1 / 2 * screenHeight,
                                                  child:
                                                      const SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "There are 4 conditions:",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Times New Roman",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                            "1. By continuing this action it may hold RM 3.00 from your credit.",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Times New Roman")),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                            "2. You need to wait for the other side confirmation (if they reject your request, your RM 3.00 credit will be given back).",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Times New Roman")),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                            "3. Once you confirm to barter the item, RM 1.00 will be deduct from your hold credit and the remaining RM 2.00 will be automatically added back to your credit",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Times New Roman")),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                            "4. Once you cancel to barter the item, RM 3.00 will be deduct from your hold credit ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Times New Roman")),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Flexible(
                                                          child:
                                                              GestureDetector(
                                                        onTap: null,
                                                        child: const Text(
                                                          "I Agree With The Terms",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            proceedProcess(
                                                                index1);
                                                          },
                                                          child: const Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            "No",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ))
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text("Proceed")),
                                  ElevatedButton(
                                    onPressed: () {
                                      print(index);
                                      var index1 = index;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: const Text(
                                                "Are you sure you want to reject this barter request?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Times New Roman"),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      rejectProcess(index1);
                                                    },
                                                    child: const Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ))
                                              ],
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 174, 46, 37),
                                      ),
                                    ),
                                    child: const Text("Reject"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ));
                      })),
        ],
      ),
    );
  }

  void loadProcess() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_process.php"),
        body: {
          "seller_id": widget.seller.id.toString(),
          "processStatus": "Pending"
        }).then((response) {
      processList.clear();
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          print(response.body);
          if (jsondata['status'] == "success") {
            var extractdata = jsondata['data'];
            extractdata['process'].forEach((v) {
              processList.add(Process.fromJson(v));
            });
          } // Replace 'data' with your JSON string or data source
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      }
      setState(() {});
    });
  }

  void proceedProcess(int index) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": processList[index].barterId,
          "processStatus": "Confirm"
        }).then((response) {
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            holdCredit(index, "Confirm");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Process Continued")));
          } // Replace 'data' with your JSON string or data source
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      }
    });
  }

  void rejectProcess(int index) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": processList[index].barterId,
          "processStatus": "Reject"
        }).then((response) async {
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            holdCredit(index, "Reject");
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Process Aborted")));
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: widget.seller,
                      )),
              (Route<dynamic> route) => false,
            );
          }
          // Continue processing the parsed JSON data
        } catch (e) {
          print("JSON Parsing Error: $e");
          // Handle the error, show a user-friendly message, etc.
        }
      }
    });
  }

  void holdCredit(int index, String status) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_credit.php"),
        body: {
          "sellerId": widget.seller.id.toString(),
          "buyerid": processList[index].buyerId.toString(),
          "processStatus": status,
        }).then((response) async {
      if (response.statusCode == 200) {
        try {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Process Continued")));
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: widget.seller,
                      )),
              (Route<dynamic> route) => false,
            );
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
