import 'dart:convert';

import 'package:barterit/models/user.dart';
import 'package:barterit/screens/billScreen.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:barterit/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/credit.dart';
import '../myConfig.dart';

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
  var creditA = 0.0;
  bool _passwordVisibility = true;
  final TextEditingController _amountEC = TextEditingController(text: "0.00");
  final TextEditingController _passEditingC = TextEditingController();
  final TextEditingController _nameEditingC = TextEditingController();
  final TextEditingController _phoneEditingC = TextEditingController();
  final TextEditingController _oldPassEditingC = TextEditingController();
  final TextEditingController _newPassEditingC = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCredit();
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
      body: SingleChildScrollView(
        child: Column(
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
            Card(
              child: SizedBox(
                width: screenW,
                child: Column(
                  children: [
                    if (creditA == 0)
                      const Text(
                        "Credits: RM 0.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    if (creditA != 0)
                      Text(
                        "Credits: RM ${creditA.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: addCreditDialog,
                          child: const Row(
                            children: [Icon(Icons.add), Text("Topup")],
                          )),
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
                                  _updateNameDialog();
                                },
                                child: const Text("EDIT NAME"),
                              ),
                            if (widget.user.id != "na")
                              Divider(
                                height: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            if (widget.user.id != "na")
                              MaterialButton(
                                onPressed: () {
                                  _updatePhoneDialog();
                                },
                                child: const Text("EDIT PHONE"),
                              ),
                            if (widget.user.id != "na")
                              Divider(
                                height: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            if (widget.user.id != "na")
                              MaterialButton(
                                onPressed: () {
                                  _changePassDialog();
                                },
                                child: const Text("EDIT PASSWORD"),
                              ),
                            if (widget.user.id != "na")
                              Divider(
                                height: 2,
                                color: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }

  void addCreditDialog() {
    if (widget.user.id != "na") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: const Text(
                "Choose the amount you want to add for credits:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Times New Roman'),
              ),
              content: SizedBox(
                height: 1 / 3.5 * screenH,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _amountEC,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Enter credit amount",
                          labelStyle: TextStyle(fontFamily: 'Times New Roman'),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          icon: Icon(
                            Icons.money,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                          obscureText: _passwordVisibility,
                          controller: _passEditingC,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Password must be longer than 3 characters";
                            } else if (val != _passEditingC.text) {
                              // nanti tukar
                              return "Passwords do not match";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.lock_outline),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            String pass = _passEditingC.text;
                            String amount = _amountEC.text;

                            payCredit(pass, amount);
                          },
                          child: const Text("Pay"))
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: const Text(
                "Please Login/ Register An Account",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text("You need an account to access this page"),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const LoginScreen()));
                    },
                    child: const Text("Login")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const RegisterScreen()));
                    },
                    child: const Text("Register")),
              ],
            );
          });
    }
  }

  payCredit(String pass, String amount) {
    if (double.parse(amount) <= 0) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Value is less than RM 0")));
      return;
    }
    if (pass == widget.user.password) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (content) => BillScreen(
                  user: widget.user,
                  amountC: amount,
                )),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password Wrong")));
    }
  }

  void loadCredit() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_credit.php"),
        body: {
          "userId": widget.user.id,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          Credit userCredit = Credit.fromJson(jsondata['data']);
          creditA = double.parse(userCredit.creditAdd.toString());
        }
        setState(() {});
      }
    });
  }

  void _updateNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Do you want to change your name?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameEditingC,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newname = _nameEditingC.text;
                _updateName(newname);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateName(String newname) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newname": newname,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully updated")));
        setState(() {
          widget.user.name = newname;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Information failed to be updated")));
      }
    });
  }

  void _updatePhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Do you want to change your phone number?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phoneEditingC,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newphone = _phoneEditingC.text;
                _updatePhone(newphone);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePhone(String newphone) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newphone": newphone,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Succesfully updated")));
        setState(() {
          widget.user.phone = newphone;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Information failed to be updated")));
      }
    });
  }

  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Do you want to change your password?",
            style: TextStyle(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldPassEditingC,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Old Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _newPassEditingC,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changePass() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "oldpass": _oldPassEditingC.text,
          "newpass": _newPassEditingC.text,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Successfully updated")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Information failed to be updated")));
      }
    });
  }
}
