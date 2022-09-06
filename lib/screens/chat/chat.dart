import 'dart:async';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:green_thumb/models/message.dart';
import 'package:green_thumb/config/global_variables.dart';
import '../../widgets/app_bar.dart';

class ChatScreen extends StatefulWidget {
  final String fullname;
  final String sellerId;
  const ChatScreen(String this.fullname, String this.sellerId, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final ChatUser user1 = ChatUser(id: '0');
final ChatUser user2 = ChatUser(id: '2', firstName: '');

final List<ChatMessage> messages = <ChatMessage>[];
final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

final ChatMessage mess = new ChatMessage(
  text: '',
  user: user2,
  createdAt: DateTime.now(),
);

bool flagChat = true;

class _ChatScreenState extends State<ChatScreen> {
  final String userIdMittente =
      user.userId; //COMPRATORE il mio id, verifico se mi arrivano messaggi

  Future<Message> getMessage() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse(url + ':3004/chat/' + userIdMittente));

    if (response.statusCode == 200 && response.body.contains('id')) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return getMessage();
    }
  }

  Stream<Message> getText() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getMessage();
    }).asyncMap((event) async => await event);
  }

  @override
  Widget build(BuildContext context) {
    final String userIdDestinatario =
        widget.sellerId; //VENDITORE quando clicco prendo l'id

    Future<http.Response> createChat() {
      return http.post(
        Uri.parse(url + ':3004/chat/'),
        body: (<String, String>{
          'content': 'Welcome in my shop and thanks for contacting me!',
          'userId': userIdDestinatario,
          'idConversation': userIdMittente
        }),
      );
    }

    Future<http.Response> sendMessage(String content, String date) {
      return http.put(
        Uri.parse(url + ':3004/chat/' + userIdDestinatario),
        body: (<String, String>{'content': content, 'created_at': date}),
      );
    }

    user2.firstName = widget.fullname;
    var size = MediaQuery.of(context).size;
    if (flagChat) {
      createChat();
      flagChat = false;
    }
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
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.1),
                child: appBarWidget(size, true)),
            body: DashChat(
              currentUser: user1,
              onSend: (ChatMessage m) {
                setState(() {
                  messages.insert(0, m);
                  sendMessage(m.text, dateFormat.format(DateTime.now()));
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
