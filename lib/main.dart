import 'package:flutter/material.dart';
import 'package:green_thumb/screens/register_page.dart';
import 'package:green_thumb/screens/sendPosition_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginRadius Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SendPositionScreen(),
    );
  }
}
