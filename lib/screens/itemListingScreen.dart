import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';

class ItemListingScreen extends StatefulWidget {
  final User user;
  const ItemListingScreen({super.key, required this.user});

  @override
  State<ItemListingScreen> createState() => _ItemListingScreenState();
}

class _ItemListingScreenState extends State<ItemListingScreen> {
  String mainTitle = "Item List";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle),
      ),
    );
  }
}
