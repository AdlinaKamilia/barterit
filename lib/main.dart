import 'package:barterit/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BarterIt',
        theme: ThemeData(
            primarySwatch: Colors.green,
            textTheme: const TextTheme(
                bodyMedium: TextStyle(
              fontFamily: 'Times New Roman',
            ))),
        home: const SplashScreen());
  }
}
