import 'dart:convert';

import 'package:barterit/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import '../myConfig.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final amountC;
  const BillScreen({super.key, required this.user, required this.amountC});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late double screenH, screenW;
  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 1 / 3 * screenH,
          decoration: BoxDecoration(
              border: Border.all(
                  style: BorderStyle.solid,
                  color: Theme.of(context).colorScheme.tertiary)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Payment Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                width: 155,
                child: ElevatedButton(
                  onPressed: () async {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Transaction Completed Successfully!',
                    );
                    await Future.delayed(const Duration(milliseconds: 2000));
                    insertCredit();
                  },
                  child: const Text("Payment Succesful"),
                ),
              ),
              SizedBox(
                  width: 155,
                  child: ElevatedButton(
                    onPressed: () async {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Transaction Failed',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Insert Credit Failed")));
                      await Future.delayed(const Duration(milliseconds: 2000));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (content) =>
                                  MainScreen(user: widget.user)));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 173, 37, 27),
                      ),
                      // You can also customize other properties such as text style, padding, etc.
                    ),
                    child: const Text("Payment Failed"),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void insertCredit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("In Process of Adding Credit"),
          content: LinearProgressIndicator(),
        );
      },
    );
    String id = widget.user.id.toString();
    String creditAdd = widget.amountC.toString();
    String creditHold = "0";
    http.post(Uri.parse("${MyConfig().server}/barterit/php/insert_credit.php"),
        body: {
          "userId": id,
          "creditAdd": creditAdd,
          "creditHold": creditHold,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Inserting Credit Success")));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (content) => MainScreen(user: widget.user),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Insert Credit Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
      }
    });
  }
}
