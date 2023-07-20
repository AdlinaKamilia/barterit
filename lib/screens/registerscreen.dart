import 'dart:convert';

import 'package:barterit/myConfig.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String mainTitle = "Registration Account";
  late double screenH, screenW;
  bool _isChecked = false;
  bool _paswordVisibility = true;
  final _formKey = GlobalKey<FormState>();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
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
        title: Text(mainTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          height: screenH * 0.4,
          width: screenW,
          color: Colors.blue.shade100,
        ),
        Container(
          height: screenH,
          width: screenW,
          margin: EdgeInsets.only(
              top: screenH /
                  8), //to adjust the margin of the card starts where..
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "REGISTRATION FORM",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Times New Roman'),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          TextFormField(
                              controller: _nameEditingController,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus);
                              },
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 3) ||
                                      (val.length > 50)
                                  ? "Name must be longer than 3 characters"
                                  : null,
                              decoration: const InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.person),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              controller: _phoneEditingController,
                              textInputAction: TextInputAction.next,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              keyboardType: TextInputType.phone,
                              validator: (val) => val!.isEmpty ||
                                      (val.length < 10) ||
                                      (val.length > 12)
                                  ? "Minimum 10 characters"
                                  : null,
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.phone),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              controller: _emailEditingController,
                              textInputAction: TextInputAction.next,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Enter a valid email"
                                  : null,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              obscureText: _paswordVisibility,
                              controller: _passEditingController,
                              textInputAction: TextInputAction.next,
                              focusNode: focus2,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus3);
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Password must be longer than 5 characters";
                                } else if (val !=
                                    _pass2EditingController.text) {
                                  return "Passwords do not match";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.lock_outline),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _paswordVisibility =
                                              !_paswordVisibility;
                                        });
                                      },
                                      icon: Icon(_paswordVisibility
                                          ? Icons.visibility
                                          : Icons.visibility_off)))),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                              obscureText: _paswordVisibility,
                              controller: _pass2EditingController,
                              textInputAction: TextInputAction.done,
                              focusNode: focus3,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus4);
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Password must be longer than 5 characters";
                                } else if (val != _passEditingController.text) {
                                  return "Passwords do not match";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Re-Enter Password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.lock_outline),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0)),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _paswordVisibility =
                                              !_paswordVisibility;
                                        });
                                      },
                                      icon: Icon(_paswordVisibility
                                          ? Icons.visibility
                                          : Icons.visibility_off)))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  }),
                              Flexible(
                                  child: GestureDetector(
                                onTap: null,
                                child: const Text(
                                  "Agree with terms",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                onPressed: _registerAcc,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                minWidth: 80,
                                height: 30,
                                elevation: 10,
                                color: Theme.of(context).colorScheme.secondary,
                                child: const Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already Register?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login Here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _registerAcc() {
    String pass1 = _passEditingController.text;
    String pass2 = _pass2EditingController.text;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Input")));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree with the conditions and terms")));
      return;
    }
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Password")));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Registering New Account"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    registerUser();
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
          );
        });
  }

  void registerUser() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Please Wait"),
            content: Text("Registration in progress"),
          );
        });
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;

    http.post(Uri.parse("${MyConfig().server}/barterit/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          insertCredit(jsondata['data'].toString());
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Successfully")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registrations Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrations Failed")));
        Navigator.pop(context);
      }
    });
  }

  void insertCredit(String userId) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/insert_credit.php"),
        body: {
          "userId": userId,
          "creditAdd": "0",
          "creditHold": "0",
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          print("credit settle");
        } else {
          print("credit failed");
        }
      } else {
        print("credit failed");
      }
    });
  }
}
//update android manifest