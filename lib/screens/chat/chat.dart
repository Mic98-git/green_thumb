import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;

class Message {
  const Message(
      {required this.messageId,
      required this.userId,
      required this.content,
      required this.createdAt});

  /// ID of the message
  final String messageId;

  /// ID of the user who posted the message
  final String userId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final String createdAt;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        messageId: json['mess'][0]['_id'],
        userId: json['mess'][0]['userId'],
        createdAt: json['mess'][0]['created_at'],
        content: json['mess'][0]['content']);
  }
}

String idDestinatario = '62fe30f5e7d2a2e6d06ef826';
String idMittente = '62fe30611f401e001333dd93';

class Profile {
  const Profile({required this.fullname, required this.userId});

  /// Username of the profile
  final String fullname;

  final String userId;

  String get getName {
    return fullname;
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        fullname: json['user']['fullname'], userId: json['user']['_id']);
  }
}

Future<Profile> getUsername() async {
  final response = await http
      // ignore: prefer_interpolation_to_compose_strings
      .get(Uri.parse('http://10.0.2.2:3000/users/' + idMittente));

  if (response.statusCode == 200) {
    print(response.body);
    return await Profile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load message');
  }
}

Future<http.Response> sendMessage(String content, String idDestinatario) {
  return http.post(
    Uri.parse('http://10.0.2.2:3005/chat/'),
    body: (<String, String>{'userId': idDestinatario, 'content': content}),
  );
}

// Future<Message> getMessage() async {
//   final response = await http
//       // ignore: prefer_interpolation_to_compose_strings
//       .get(Uri.parse('http://10.0.2.2:3005/chat/' + idMittente));

//   if (response.statusCode == 200) {
//     print(response.body);
//     return Message.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load message');
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: types.User(id: "user.userId", firstName: "user.fullname"),
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  String idDestinatario = '62fe30f5e7d2a2e6d06ef826';

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: types.User(id: "user.userId", firstName: "user.fullname"),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: idDestinatario,
      text: message.text,
    );

    print(message.text);

    String content = message.text;

    sendMessage(content, idDestinatario);

    _addMessage(textMessage);
  }
}
