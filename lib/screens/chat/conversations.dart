import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/models/message.dart';
import 'package:green_thumb/screens/chat/chat.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../widgets/app_bar.dart';
import '../../widgets/navigation_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: ConversationScreen(),
      );
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String mioId = user.userId;
  bool checkMessages = false;

  Future<Message> getMessage() async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse(url + ':3004/chat/' + mioId));

    if (response.statusCode == 200 && response.body.contains('id')) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return getMessage();
    }
  }

  Future<User> getUsername(idMittente) async {
    final response = await http
        // ignore: prefer_interpolation_to_compose_strings
        .get(Uri.parse(url + ':3000/users/' + idMittente));

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
    String fullname = '';
    int _currentIndex = 2;
    return WillPopScope(
        onWillPop: () async => false,
        child: new StreamBuilder<Message>(
            stream: getText(),
            builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
              if (snapshot.hasData) {
                getUsername(snapshot.data!.idConversation)
                    .then((value) => fullname = value.fullname);
              }
              return Scaffold(
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(size.height * 0.09),
                      child: appBarWidget(size, false)),
                  bottomNavigationBar:
                      BottomNavigationBarScreen(currentIndex: _currentIndex),
                  body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Conversations",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        !snapshot.hasData
                            ? Text("No message here",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey))
                            : fullname.isNotEmpty
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder: (context, i) => Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              size.height * 0.005),
                                          child: ListTile(
                                              leading: Image.asset(
                                                  'assets/images/image.png'),
                                              title: Text(fullname),
                                              onTap: () async {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (_) => ChatScreen(
                                                            fullname,
                                                            snapshot.data!
                                                                .idConversation)));
                                              }),
                                        )))
                                : Row()
                      ])));
            }));
  }
}
