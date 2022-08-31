import 'dart:core';

import 'package:flutter/material.dart';
import 'package:green_thumb/core/api_client.dart';
import '../config/global_variables.dart';
import '../widgets/app_bar.dart';
import '../widgets/navigation_bar.dart';

class HomePageScreen extends StatefulWidget {
  static String id = "home_page_screen";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.09),
                child: appBarWidget(size, false)),
            backgroundColor: Colors.white,
            bottomNavigationBar:
                BottomNavigationBarScreen(currentIndex: _currentIndex),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [],
                )),
          ),
        ));
  }
}
