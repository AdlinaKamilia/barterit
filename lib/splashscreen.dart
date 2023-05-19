import 'dart:async';
import 'dart:convert';
import 'package:barterit/models/user.dart';
import 'package:barterit/myConfig.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double screenH, screenW;
  @override
  void initState() {
    super.initState();
    //Timer(
    //    const Duration(seconds: 5),
    //    () => Navigator.pushReplacement(context,
    //        MaterialPageRoute(builder: (content) => MainScreen())));
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              height: screenW * 0.65,
              width: screenW * 0.65,
              color: const Color.fromRGBO(19, 19, 19, 100),
              padding: const EdgeInsets.all(7),
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenH * 0.2,
                        width: screenW * 0.2,
                        child: Image.asset("assets/images/barter.png"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "BarterIt",
                        style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 24,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 4,
                        width: 100,
                        child: LinearProgressIndicator(),
                      )
                      // Specify the progress value between 0.0 and 1.0
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  void checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;

    if (ischeck) {
      try {
        http.post(Uri.parse("${MyConfig().server}/barterit/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == 'success') {
              user = User.fromJson(jsondata['data']);
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            } else {
              user = User(
                  id: "na",
                  name: "na",
                  email: "na",
                  phone: "na",
                  datereg: "na",
                  password: "na",
                  otp: "na");
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            }
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {});
      } on TimeoutException catch (_) {
        print("timeout");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
