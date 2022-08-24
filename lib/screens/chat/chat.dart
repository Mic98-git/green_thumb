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

// Widget getMessageWidget(BuildContext context) {
//   return DefaultTextStyle(
//     style: Theme.of(context).textTheme.displayMedium!,
//     textAlign: TextAlign.center,
//     child: FutureBuilder<Message>(
//       future: getMessage(), // a previously-obtained Future<String> or null
//       builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
//         if (snapshot.hasData) {
//           messages.add(ChatMessage(
//             text: snapshot.data!.content,
//             user: user2,
//             createdAt: DateTime(2021, 01, 30, 16, 45),
//           ));
//         }
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//           ),
//         );
//       },
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Basic example'),
//       ),
//       body: DashChat(
//         currentUser: user,
//         onSend: (ChatMessage m) {
//           setState(() {
//             messages.insert(0, m);
//           });
//         },
//         messages: messages,
//         messageListOptions: MessageListOptions(
//           onLoadEarlier: () async {
//             await Future.delayed(const Duration(seconds: 3));
//           },
//         ),
//       ),
//     );
//   }
// }
