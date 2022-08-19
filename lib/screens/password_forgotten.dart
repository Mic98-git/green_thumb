import 'package:flutter/material.dart';
import 'package:green_thumb/utils/validator.dart';
import '../../colors.dart';

class PasswordForgottenScreen extends StatefulWidget {
  static String id = "pw_forgotten_screen";
  const PasswordForgottenScreen({Key? key}) : super(key: key);

  @override
  State<PasswordForgottenScreen> createState() =>
      _PasswordForgottenScreenState();
}

class _PasswordForgottenScreenState extends State<PasswordForgottenScreen> {
  final TextEditingController emailController = TextEditingController();
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
                'Please insert your email',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  return Validator.validateEmail(value ?? "");
                },
                decoration: InputDecoration(
                  hintText: "Email",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
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
                        builder: (context) => const PasswordForgottenScreen()));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Icon(Icons.double_arrow_outlined),
                  ]),
            ),
          ),
        ]));
  }
}
