import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/screens/chat/chat.dart';
import 'package:green_thumb/screens/login_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'custom_material_color.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class Profile {
  const Profile({required this.fullname});

  /// Username of the profile
  final String fullname;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(fullname: json['user']['fullname']);
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  String idDestinatario = '62fe30611f401e001333dd93';

  Future<Profile> getUsername() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse('http://10.0.2.2:3000/users/' + idDestinatario));

    if (response.statusCode == 200) {
      print(response.body);
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Profile> destinatario = getUsername();
    AsyncSnapshot snapshot = new AsyncSnapshot.waiting();
    if (snapshot.hasData) {
      String fullname = snapshot.data.fullname;
      String id = snapshot.data.id;
    }
    return MaterialApp(
      title: 'GreenThumb ecommerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color.fromRGBO(51, 153, 66, 1)),
      ),
      home: ChatPage(
        id: "ciao",
        username: "ciao",
      ),
    );
  }
}
