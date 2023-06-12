import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final User user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String mainTitle = "Messages";
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mainTitle,
        ),
      ),
    );
  }
}
