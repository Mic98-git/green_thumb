import 'dart:async';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:green_thumb/models/message.dart';

import '../../widgets/app_bar.dart';

class ChatScreen extends StatefulWidget {
  final String fullname;
  const ChatScreen(String this.fullname, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

ChatUser user = ChatUser(id: '0');
ChatUser user2 = ChatUser(id: '2', firstName: '');

List<ChatMessage> messages = <ChatMessage>[];
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

ChatMessage mess = new ChatMessage(
  text: '',
  user: user2,
  createdAt: DateTime.now(),
);

class _ChatScreenState extends State<ChatScreen> {
  String userIdMittente =
      '6308c9876991b40012a08682'; //COMPRATORE il mio id, verifico se mi arrivano messaggi

  Future<Message> getMessage() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse('http://10.0.2.2:3005/chat/' + userIdMittente));

    if (response.statusCode == 200 && !response.body.endsWith('null}')) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message, maybe does not exists');
    }
  }

  Stream<Message> getText() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getMessage();
    }).asyncMap((event) async => await event);
  }

  String userIdDestinatario =
      '6308c9956991b40012a08684'; //VENDITORE quando clicco prendo l'id

  Future<http.Response> createChat() {
    return http.post(
      Uri.parse('http://10.0.2.2:3005/chat/'),
      body: (<String, String>{
        'content': ' ',
        'userId': userIdDestinatario,
        'idConversation': userIdMittente
      }),
    );
  }

  // String idChat = ''; //ID della chat quando è stata creata con la post

  Future<http.Response> sendMessage(String content, String date) {
    return http.put(
      Uri.parse('http://10.0.2.2:3005/chat/' + userIdDestinatario),
      body: (<String, String>{'content': content, 'created_at': date}),
    );
  }

  @override
  Widget build(BuildContext context) {
    user2.firstName = widget.fullname;
    var size = MediaQuery.of(context).size;
    createChat();
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
              currentUser: user,
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