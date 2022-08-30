import 'package:flutter/material.dart';
import 'package:green_thumb/models/article.dart';

const primaryColor = Color.fromRGBO(51, 153, 0, 1);
const backgroundColor = Color.fromRGBO(220, 230, 217, 1.0);
const articleBoxColor = Color.fromRGBO(247, 234, 213, 1);
final bool isLoggedIn = false;

String url = 'http://valeriobob.ddns.net';
// String url = 'http://10.0.2.2';

late final User user;

String registeredUserId = '';
String registeredFullname = '';

class User {
  final bool isCustomer;
  // final bool isSeller;
  final String fullname;
  final String birth;
  final String fiscalcode;
  final String email;
  final String userId;
  //final String token;
  const User({
    Key? key,
    required this.isCustomer,
    required this.fullname,
    required this.birth,
    required this.fiscalcode,
    required this.email,
    required this.userId,
    //required this.token,
  }) : super();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      isCustomer: json['user']['isCustomer'],
      fullname: json['user']['fullname'],
      birth: json['user']['birth'],
      fiscalcode: json['user']['fiscalcode'],
      email: json['user']['email'],
      userId: json['user']['id'],
      //token: json['user']['token']
    );
  }
}

var shoppingCartItems = Map<String, Article>(); //<articleId, Article>
