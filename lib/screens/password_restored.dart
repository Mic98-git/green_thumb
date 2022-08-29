import 'package:flutter/material.dart';
import '../config/global_variables.dart';
import './login_page.dart';

class PasswordRestoredScreen extends StatefulWidget {
  static String id = "pass_restored_screen";
  const PasswordRestoredScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRestoredScreen> createState() => _PasswordRestoredScreenState();
}

class _PasswordRestoredScreenState extends State<PasswordRestoredScreen> {
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
                    'Email sent',
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
                      child: Image.asset(
                          'assets/images/registration_completed.png')),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Hi, check your inbox to restore the password and proceed with the login. "
                          "Regards from the GreenThumb Team!",
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
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login ',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Icon(Icons.double_arrow_outlined, size: 30),
                      ]),
                ),
              ),
            ])));
  }
}
