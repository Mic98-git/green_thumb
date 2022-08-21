import 'package:flutter/material.dart';
import '../../colors.dart';

class AnnouncementCreationCompletedScreen extends StatefulWidget {
  static String id = "announcement_completed_screen";
  const AnnouncementCreationCompletedScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementCreationCompletedScreen> createState() =>
      _AnnouncementCreationCompletedScreenState();
}

class _AnnouncementCreationCompletedScreenState
    extends State<AnnouncementCreationCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Text(
                'Announcement posted',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Container(
                  width: 150,
                  height: 150,
                  child:
                      Image.asset('assets/images/registration_completed.png')),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Article posted!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              )),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Please wait for the approval and check your inbox. "
                      "Thanks for sharing on GreenThumb!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )))),
          SizedBox(
            height: size.height * 0.06,
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {},
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'My Account',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Icon(
                      Icons.account_circle_outlined,
                      size: 30,
                    ),
                  ]),
            ),
          ),
        ]));
  }
}
