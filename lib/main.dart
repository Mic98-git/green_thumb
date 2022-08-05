import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'geolocation',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeSampleState();
}

class HomeSampleState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Ugh oh! Something went wrong");

          if (!snapshot.hasData) return Text("Got no data :(");

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done)
            return HomeView();

          return Text("Loading please...");
        },
      ),
    );
  }
}
