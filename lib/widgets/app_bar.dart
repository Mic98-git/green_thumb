import 'package:flutter/material.dart';

Widget appBarWidget(Size size, bool back, String title) {
  return AppBar(
    title: Text(title),
    automaticallyImplyLeading: back,
    actions: <Widget>[
      TextButton(
        onPressed: () {},
        child: const Text('GreenThumb',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      SizedBox(
        width: size.width * 0.05,
      )
    ],
  );
}
