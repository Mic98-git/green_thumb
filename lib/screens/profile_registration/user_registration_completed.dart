import 'package:flutter/material.dart';
import '../activity_registration/activity_info.dart';
import '../../config/global_variables.dart';
import '../login_page.dart';

class UserRegistrationCompletedScreen extends StatefulWidget {
  static String id = "registration_completed_screen";
  final String name;
  final bool isCustomer;
  const UserRegistrationCompletedScreen(
      {Key? key, required this.name, required this.isCustomer})
      : super(key: key);

  @override
  State<UserRegistrationCompletedScreen> createState() =>
      _UserRegistrationCompletedScreenState();
}

class _UserRegistrationCompletedScreenState
    extends State<UserRegistrationCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
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
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                          'assets/images/registration_completed.png')),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                      "Dear " +
                          widget.name +
                          ", we are glad to see you here!"
                              " Your account has been created.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ))),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: widget.isCustomer
                          ? Text("Please login and start buying something!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ))
                          : Text(
                              "Please continue the registration providing activity details!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                height: 50,
                width: 260,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    widget.isCustomer
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ActivityInfoScreen()));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.isCustomer
                            ? Text(
                                'Login ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )
                            : Text(
                                'Register Activity',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                        widget.isCustomer
                            ? Icon(Icons.double_arrow_outlined, size: 30)
                            : Icon(Icons.double_arrow_outlined)
                      ]),
                ),
              ),
            ])));
  }
}
