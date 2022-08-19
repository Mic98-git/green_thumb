import 'package:flutter/material.dart';
import '../../colors.dart';

class RegistrationCompletedScreen extends StatefulWidget {
  static String id = "login_screen";
  const RegistrationCompletedScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationCompletedScreen> createState() =>
      _RegistrationCompletedScreenState();
}

class _RegistrationCompletedScreenState
    extends State<RegistrationCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Text(
                'Welcome on Green Thumb',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const RegistrationCompletedScreen()));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Home Page',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Icon(Icons.double_arrow_outlined),
                  ]),
            ),
          ),
        ]));
  }
}
