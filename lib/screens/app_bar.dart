import 'package:flutter/material.dart';

Widget appBarWidget(Size size) {
  return AppBar(
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
