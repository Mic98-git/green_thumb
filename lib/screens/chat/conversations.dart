import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/models/message.dart';
import 'package:green_thumb/models/user.dart';
import 'package:green_thumb/screens/chat/chat.dart';
import 'package:http/http.dart' as http;

import '../../widgets/app_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: ConversationPage(),
      );
}

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  String mioId =
      '6308c9956991b40012a08684'; //VENDITORE quando clicco prendo l'id

  Future<Message> getMessage() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse('http://10.0.2.2:3005/chat/' + mioId));

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  Future<User> getUsername(idMittente) async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse('http://10.0.2.2:3000/users/' + idMittente));

    if (response.statusCode == 200) {
      //print(response.body);
      return await User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  Stream<Message> getText() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getMessage();
    }).asyncMap((event) async => await event);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    late String fullname = '';
    return new StreamBuilder<Message>(
        stream: getText(),
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          if (snapshot.hasData) {
            getUsername(snapshot.data!.idConversation)
                .then((value) => fullname = value.fullname);
          }
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.1),
                child: appBarWidget(size, true, 'Conversations')),
            body: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, i) => ListTile(
                    title: Text(fullname),
                    onTap: () async {
                      await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => MyHomePage()));
                    })),
          );
        });
  }
}
