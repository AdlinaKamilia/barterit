import 'package:barterit/models/user.dart';

import 'package:barterit/screens/itemListingScreen.dart';
import 'package:barterit/screens/messageScreen.dart';
import 'package:barterit/screens/profilescreen.dart';
import 'package:barterit/screens/ratingreviewscreen.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchild;
  int _currInd = 0;
  late String mainTitle;
  @override
  void initState() {
    super.initState();
    tabchild = [
      ItemListingScreen(user: widget.user),
      RatingReviewScreen(user: widget.user),
      MessageScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchild[_currInd],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTap,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currInd,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Item"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Review"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2), label: "Profile"),
          ]),
    );
  }

  void onTabTap(int value) {
    setState(() {
      _currInd = value;
      if (_currInd == 0) {
        mainTitle = "Item";
      }
      if (_currInd == 1) {
        mainTitle = "Rating";
      }
      if (_currInd == 2) {
        mainTitle = "Messages";
      }
      if (_currInd == 3) {
        mainTitle = "Profile";
      }
    });
  }
}
