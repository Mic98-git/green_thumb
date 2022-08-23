import 'package:flutter/material.dart';
import 'package:green_thumb/colors.dart';
import 'app_bar.dart';
import 'navigation_bar.dart';
import './announcement_creation/new_article.dart';

class MyAccountScreen extends StatefulWidget {
  static String id = "MyAccount_screen";
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.1),
            child: appBarWidget(size)),
        backgroundColor: Colors.white,
        bottomNavigationBar:
            BottomNavigationBarScreen(currentIndex: _currentIndex),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "My Account",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Stack(alignment: Alignment.centerRight, children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 70,
                      child: CircleAvatar(
                        radius: 65,
                        //backgroundImage:
                        backgroundColor: Colors.white,
                      ),
                    )),
              ),
              Container(
                  height: size.height * 0.25,
                  width: size.width * 0.55,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            children: [
                              Text(
                                'My Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 85,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewArticleScreen()));*/
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Edit ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewArticleScreen()));
                                  },
                                  child: Text(
                                    'New Announcement',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))),
            ]),
          ],
        ));
  }
}
