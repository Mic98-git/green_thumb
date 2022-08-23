import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

class ChatPage extends StatefulWidget {
  String id;
  String username;

  ChatPage({
    required this.id,
    required this.username,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _ctrlMess = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: StreamBuilder(
        initialData: null,
        stream: getStream(),
        builder: (context, AsyncSnapshot snap) {
          if (snap.hasData) {
            return Column(
              children: <Widget>[
                StreamBuilder(
                  builder: (context, snap) {
                    List<dynamic>? lst = snap.data as List?;
                    if (lst != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: lst.length,
                          itemBuilder: (context, index) {
                            var username = lst[index]['user'];
                            var mess = lst[index]['content'].toString();
                            return Container(
                              margin: username == widget.username
                                  ? EdgeInsets.only(
                                      right: 2, bottom: 5, top: 5, left: 100)
                                  : EdgeInsets.only(
                                      right: 100, bottom: 5, top: 5, left: 2),
                              padding: EdgeInsets.all(13),
                              child: Text(
                                mess,
                                textAlign: username == widget.username
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: TextStyle(
                                    color: username == widget.username
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              decoration: BoxDecoration(
                                color: username == widget.username
                                    ? Colors.blue[400]
                                    : Colors.blueGrey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Divider(
                  color: Colors.blueAccent,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: _ctrlMess,
                      decoration:
                          new InputDecoration.collapsed(hintText: "Write Here"),
                    )),
                    Container(
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            String content = _ctrlMess.text.trim();
                            if (content.isNotEmpty) {
                              var res = await sendMessage(content);
                              print(res);
                              _ctrlMess.text = "";
                            } else {
                              print("empty");
                            }
                          }),
                    )
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String idDestinatario = '62fe30f5e7d2a2e6d06ef826';
  String idMittente = '62fe30611f401e001333dd93';

  Future<Message> sendMessage(String content) async {
    final response = await http.post(Uri.parse('http://10.0.2.2:3005/chat'),
        body: {'userId': idMittente, 'content': content});

    if (response.statusCode == 200) {
      print(response.body);
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load message');
    }
  }

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

  // Future<List<dynamic>> _getData(int value) async {
  //   var res =
  //       await http.post('http://192.168.1.107/chat/api/get_mess.php', body: {
  //     'username': widget.user.username,
  //     'password': widget.user.password,
  //     'user_to': widget.userTo.username
  //   });
  //   var jsonx = json.decode(res.body);
  //   return jsonx;
  // }

  Stream<dynamic> getStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getMessage();
    }).asyncMap((event) async => await event);
  }

  // Stream<Future<List<dynamic>>> _stream() {
  //   Duration interval = Duration(seconds: 1);
  //   // Stream<Future<List<dynamic>>> stream =
  //   //     Stream<Future<List<dynamic>>>.periodic(interval, getMessage());
  //    Stream<Future<List<dynamic>>> stream = getMessage() as Stream<Future<List>>;
  //   return stream;
  // }

  // Future<Profile> getUsername() async {
  //   final response = await http
  //       // ignore: prefer_interpolation_to_compose_strings
  //       .get(Uri.parse('http://10.0.2.2:3000/users/' + idMittente));

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return Profile.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load message');
  //   }
  // }

  // _sendMess(String content) async {
  //   var res =
  //       await http.post('http://192.168.1.107/chat/api/send_mess.php', body: {
  //     'username': widget.user.username,
  //     'password': widget.user.password,
  //     'user_to': widget.userTo.username,
  //     'content': content
  //   });
  //   return res.body;
  // }
}
