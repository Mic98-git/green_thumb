import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:green_thumb/models/article.dart';
import 'package:green_thumb/screens/my_account.dart';
import 'package:green_thumb/utils/validator.dart';
import 'package:green_thumb/core/api_client.dart';
import './profile_registration/user_info.dart';
import '../config/global_variables.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  Future<dynamic> getCart(String cartId) async {
    dynamic res = await _apiClient.getCart(cartId);
    List<String> products = [];
    if (res['error'] == null && res['cart'].length > 0) {
      print(res['cart'][0]['cartItems']);
      shoppingCartRequest = res['cart'][0]['cartItems'];
      for (var p in res['cart'][0]['cartItems']) {
        products.add(p['productId']);
      }
      dynamic res1 = await _apiClient.getProductsByList(products);
      if (res1['error'] == null) {
        for (var a in res1['products']) {
          final base64String = a['picture'];
          Image articleImage = Image.memory(base64Decode(base64String));
          shoppingCartItems.addEntries((<String, Article>{
            a['_id']: new Article(
                a['_id'],
                a['sellerId'],
                a['sellerName'],
                a['name'],
                a['latin'],
                a['description'],
                a['category'],
                a['water'],
                a['oxygen'].toString(),
                a['sunlight'],
                a['price'].toString(),
                articleImage,
                a['quantityStock'].toString())
          }).entries);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res1['error']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    } else if (res['cart'].length == 0) {
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      dynamic res = await _apiClient.login(
        emailController.text,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['error'] == null) {
        user = new User(
            isCustomer: res['isCustomer'],
            fullname: res['fullname'],
            birth: res['birth'],
            fiscalcode: res['fiscalcode'],
            email: res['email'],
            userId: res['id'],
            ratingValue: res['ratingValue'],
            numberOfRatings: res['numberOfRatings']
            //token: res['token']
            );

        getCart(user.userId);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyAccountScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['error']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height.toDouble() * 0.06),
                          child: Center(
                            child: Container(
                                width: 100,
                                height: 80,
                                child: Image.asset('assets/images/logo.png')),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height.toDouble() * 0.02),
                          child: Text(
                            'GreenThumb',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.6,
                          height: size.height * 0.02,
                          child: Divider(color: primaryColor),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Your way to greenification',
                            style: TextStyle(color: primaryColor, fontSize: 15),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
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
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            obscureText: !_showPassword,
                            controller: passwordController,
                            validator: (value) {
                              return Validator.validatePassword(value ?? "");
                            },
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
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
                            onPressed: login,
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'New User? Please, ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserInfoScreen()));
                                },
                                child: Text(
                                  'register here!',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ))));
  }
}
