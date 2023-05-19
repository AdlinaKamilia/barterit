import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';

class RatingReviewScreen extends StatefulWidget {
  final User user;
  const RatingReviewScreen({super.key, required this.user});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  String mainTitle = "Rating And Review";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle),
      ),
    );
  }
}
