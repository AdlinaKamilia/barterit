import 'dart:convert';

import 'package:barterit/models/process.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../myConfig.dart';

class ContactItemS extends StatefulWidget {
  final User user;
  final Process processItem;
  const ContactItemS(
      {super.key, required this.processItem, required this.user});

  @override
  State<ContactItemS> createState() => _ContactItemSState();
}

class _ContactItemSState extends State<ContactItemS> {
  late double screenHeight, screenWidth;
  final df = DateFormat('dd-MM-yyyy');
  var sEmail, sName, sPhone, bEmail, bName, bPhone;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBuyerData();
    loadSellerData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Seller Item Details")),
        body: Container(
          width: screenWidth, // Specify the desired width
          height: screenHeight, // Specify the desired height
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Card(
                        child: SizedBox(
                          width: screenWidth,
                          child: CachedNetworkImage(
                            width: screenWidth,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${MyConfig().server}/barterit/assets/items/${widget.processItem.sellerItemId}_1.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 5),
                Text(
                  widget.processItem.sellerItemName.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  child: Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Table(
                          border: TableBorder.all(
                              color: Theme.of(context).colorScheme.secondary),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(6)
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    "Description",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(widget
                                    .processItem.sellerItemDescription
                                    .toString()),
                              ))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Item Type",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(widget.processItem.sellerItemType
                                    .toString()),
                              ))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Quantity Available",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(widget.processItem.sellerItemQty
                                    .toString()),
                              ))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Item Price",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    "RM ${double.parse(widget.processItem.sellerItemPrice.toString()).toStringAsFixed(2)}"),
                              ))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    "${widget.processItem.sellerItemLocal}/${widget.processItem.sellerItemState}"),
                              ))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    df.format(DateTime.parse(widget
                                        .processItem.sellerItemDate
                                        .toString())),
                                  ),
                                ),
                              )
                            ]),
                          ],
                        ),
                      )),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (widget.user.id == widget.processItem.buyerId) {
                            updateBuyerAnswer();
                          } else if (widget.user.id ==
                              widget.processItem.sellerId) {
                            updateSellerAnswer();
                          }
                        },
                        child: const Text("Barter Done")),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: const Text(
                                  "Are you sure you want to cancel this barter?",
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: SizedBox(
                                  height: 1 / 10 * screenHeight,
                                  child: const Text(
                                      "Both parties will lose RM 3.00"),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        if (widget.user.id ==
                                            widget.processItem.buyerId) {
                                          cancelBuyerAnswer();
                                        } else if (widget.user.id ==
                                            widget.processItem.sellerId) {
                                          cancelSellerAnswer();
                                        }
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 162, 183, 138),
                                            fontWeight: FontWeight.bold),
                                      )),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 202, 22, 22),
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              );
                            });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 174, 46, 37),
                        ),
                      ),
                      child: const Text("Cancel Barter"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async {
            loadSellerData();
            loadBuyerData();
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text(
                      "Seller & Buyer Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times New Roman"),
                    ),
                    content: Container(
                      height: 1 / 2.5 * screenHeight,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Seller Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Seller Name : $sName",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Seller Email : $sEmail",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Seller Phone Number : $sPhone",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Buyer Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Buyer Name : $bName",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Buyer Email : $bEmail",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Buyer Phone Number : $bPhone",
                                style: const TextStyle(
                                    fontFamily: "Times New Roman")),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ],
                  );
                });
          },
          child: Icon(Icons.phone),
        ));
  }

  void loadSellerData() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_seller.php"),
        body: {
          "seller_id": widget.processItem.sellerId.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          sName = jsondata['data']['name'].toString();
          sEmail = jsondata['data']['email'].toString();
          sPhone = jsondata['data']['phone'].toString();
        }
      }
      setState(() {});
      return;
    });
  }

  void loadBuyerData() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_seller.php"),
        body: {
          "buyer_id": widget.processItem.buyerId.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          bName = jsondata['data']['name'].toString();
          bEmail = jsondata['data']['email'].toString();
          bPhone = jsondata['data']['phone'].toString();
        }
      }
      setState(() {});
    });
    return;
  }

  void updateBuyerAnswer() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": widget.processItem.barterId.toString(),
          "buyerid": widget.user.id.toString(),
          "buyerAns": "Done",
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.pop(context);
          var statusProcess = jsondata['data'];
          print(statusProcess);

          if (statusProcess == "Completed") {
            updateCredit(statusProcess);
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Updated")));
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Process Failed To Be Updated")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void updateSellerAnswer() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": widget.processItem.barterId.toString(),
          "sellerid": widget.user.id.toString(),
          "sellerAns": "Done",
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.pop(context);
          var statusProcess = jsondata['data'];
          print(statusProcess);
          if (statusProcess == "Completed") {
            updateCredit(statusProcess);
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Updated")));
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Process Failed To Be Updated")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void cancelBuyerAnswer() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": widget.processItem.barterId.toString(),
          "buyerid": widget.user.id.toString(),
          "buyerAns": "Cancel",
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.pop(context);
          var statusProcess = jsondata['data'];

          updateCredit(statusProcess);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Updated")));
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Process Failed To Be Updated")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void cancelSellerAnswer() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_process.php"),
        body: {
          "processId": widget.processItem.barterId.toString(),
          "sellerid": widget.user.id.toString(),
          "sellerAns": "Cancel",
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Navigator.pop(context);
          var statusProcess = jsondata['data'];
          updateCredit(statusProcess);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Updated")));
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Process Failed To Be Updated")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void updateCredit(var statusP) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_credit.php"),
        body: {
          "sellerId": widget.processItem.sellerId.toString(),
          "buyerid": widget.processItem.buyerId.toString(),
          "processId": widget.processItem.barterId.toString(),
          "processStatus": statusP.toString(),
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          if (statusP.toString() != "Rejected") {
            updateItem();
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void updateItem() {
    print(widget.processItem.sellerItemId.toString());
    print(widget.processItem.buyerItemId.toString());
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_item.php"),
        body: {
          "sellerItemId": widget.processItem.sellerItemId.toString(),
          "buyerItemId": widget.processItem.buyerItemId.toString(),
          "processId": widget.processItem.barterId.toString(),
        }).then((response) async {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          print("Success");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Process Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }
}
