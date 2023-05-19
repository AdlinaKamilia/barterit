import 'dart:async';
import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/myConfig.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:barterit/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mainTitle = "Login Account";
  late double screenH, screenW;
  bool _isChecked = false;
  bool _passwordVisibility = true;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailEditingController =
      TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadPref();
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
          SizedBox(
            height: screenH * 0.4,
            width: screenW,
            child: Image.asset(
              "assets/images/login.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: screenH,
            width: screenW,
            margin: EdgeInsets.only(
                top: screenH /
                    5), //to adjust the margin of the card starts where..
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "LOGIN INFORMATION",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Times New Roman'),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                                controller: _emailEditingController,
                                textInputAction: TextInputAction.next,
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
                                obscureText: _passwordVisibility,
                                controller: _passEditingController,
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Password must be longer than 5 characters";
                                  } else if (val !=
                                      _passEditingController.text) {
                                    // nanti tukar
                                    return "Passwords do not match";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(),
                                    icon: const Icon(Icons.lock_outline),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisibility =
                                                !_passwordVisibility;
                                          });
                                        },
                                        icon: Icon(_passwordVisibility
                                            ? Icons.visibility
                                            : Icons.visibility_off)))),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      saveremovepreferences(value!);
                                      setState(() {
                                        _isChecked = value;
                                      });
                                    }),
                                Flexible(
                                    child: GestureDetector(
                                  onTap: null,
                                  child: const Text(
                                    "Remember Me",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                MaterialButton(
                                  onPressed: _loginAcc,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  minWidth: 80,
                                  height: 30,
                                  elevation: 10,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: const Text(
                                    "Login",
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) =>
                                      const RegisterScreen()));
                        },
                        child: const Text(
                          "New Account?",
                        ),
                      ),
                      GestureDetector(
                        onTap: _forgotPassword(),
                        child: const Text(
                          "Forgot Password?",
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  void _loginAcc() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
    }
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    try {
      http.post(Uri.parse("${MyConfig().server}/barterit/php/login_user.php"),
          body: {
            'email': email,
            'password': password,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            print(user.email);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(user: user)),
              (Route<dynamic> route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login Failed: Incorrect Email/Password")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {});
    } on TimeoutException catch (_) {
      print("Time Out");
    }
  }

  Future<void> saveremovepreferences(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (value) {
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await preferences.setString('email', email);
      await preferences.setString('password', password);
      await preferences.setBool('checkbox', value);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Updated")));
    } else {
      await preferences.setString('email', '');
      await preferences.setString('password', '');
      await preferences.setBool('checkbox', false);

      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  _forgotPassword() {}

  loadPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = (preferences.getString('email')) ?? '';
    String password = (preferences.getString('password')) ?? '';
    _isChecked = (preferences.getBool('checkbox')) ?? false;

    if (_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
      });
    }
  }
}
