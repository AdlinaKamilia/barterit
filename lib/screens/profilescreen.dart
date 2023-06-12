import 'package:barterit/models/user.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:barterit/screens/registerscreen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String mainTitle = "Profile";
  late double screenH, screenW;
  late User user;
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
    print(mainTitle);
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mainTitle,
        ),
      ),
      body: Column(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                      radius: 50,
                      child: ClipOval(child: Icon(Icons.people, size: 70))),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.user.id != "na")
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        if (widget.user.id == "na")
                          const Text(
                            "Not Available",
                            style: TextStyle(fontSize: 20),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.user.id != "na")
                              Text(widget.user.email.toString()),
                            if (widget.user.id != "na")
                              Text(widget.user.phone.toString()),
                            if (widget.user.id != "na")
                              Text(widget.user.datereg.toString()),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              //height: screenH * 0.4,
              width: screenW,
              //padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: screenW,
                      color: Theme.of(context).colorScheme.background,
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          if (widget.user.id == "na")
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const LoginScreen()));
                              },
                              child: const Text("LOGIN"),
                            ),
                          if (widget.user.id == "na")
                            Divider(
                              height: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          if (widget.user.id == "na")
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const RegisterScreen()));
                              },
                              child: const Text("REGISTRATION"),
                            ),
                          if (widget.user.id != "na")
                            MaterialButton(
                              onPressed: () {
                                user = User(
                                    id: "na",
                                    name: "na",
                                    email: "na",
                                    phone: "na",
                                    datereg: "na",
                                    password: "na",
                                    otp: "na");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainScreen(user: user)),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text("LOGOUT"),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
