import 'dart:async';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

// String idMittente = '62fe30611f401e001333dd93';

// Future<Profile> getUsername() async {
//   final response = await http
//       // ignore: prefer_interpolation_to_compose_strings
//       .get(Uri.parse('http://10.0.2.2:3000/users/' + idMittente));

//   if (response.statusCode == 200) {
//     print(response.body);
//     return await Profile.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load message');
//   }
// }

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

ChatUser user = ChatUser(id: '0');
ChatUser user2 = ChatUser(id: '2', firstName: 'Niki Lauda');

List<ChatMessage> messages = <ChatMessage>[];

ChatMessage mess = new ChatMessage(
  text: '',
  user: user2,
  createdAt: DateTime.now(),
);

class _MyHomePageState extends State<MyHomePage> {
  String idMittente = '62fe30f5e7d2a2e6d06ef826';

  Future<Message> getMessage() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse('http://10.0.2.2:3005/chat/' + idMittente));

    if (response.statusCode == 200) {
      print(response.body);
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

  Stream<Message> getText() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getMessage();
    }).asyncMap((event) async => await event);
  }

  Future<http.Response> sendMessage(String content, String idChat) {
    return http.put(
      Uri.parse('http://10.0.2.2:3005/chat/' + idChat),
      body: (<String, String>{'content': content}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Message>(
        stream: getText(),
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          if (snapshot.hasData) {
            if (mess.text != snapshot.data!.content) {
              ChatMessage newMess = new ChatMessage(
                  text: snapshot.data!.content,
                  user: user2,
                  createdAt: DateTime.parse(snapshot.data!.createdAt));
              messages.insert(0, newMess);
              mess.text = snapshot.data!.content;
              mess.createdAt = DateTime.parse(snapshot.data!.createdAt);
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Basic example'),
            ),
            body: DashChat(
              currentUser: user,
              onSend: (ChatMessage m) {
                setState(() {
                  messages.insert(0, m);
                  sendMessage(m.text, '63066b91135c2f2bdcbd51d2');
                });
              },
              messages: messages,
              messageListOptions: MessageListOptions(
                onLoadEarlier: () async {
                  await Future.delayed(const Duration(seconds: 3));
                },
              ),
            ),
          );
        });
  }
}
