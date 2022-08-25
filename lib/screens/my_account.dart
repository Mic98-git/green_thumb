import 'package:flutter/material.dart';
import 'package:green_thumb/global_variables.dart';
import 'app_bar.dart';
import 'navigation_bar.dart';
import './announcement_creation/new_article.dart';
import './article.dart';

class MyAccountScreen extends StatefulWidget {
  static String id = "my_account_screen";
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget articleBox({required Article item}) => Container(
        width: 200,
        color: articleBoxColor,
        child: Column(children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    /*child: Material(
                      child: 
                    )*/
                  )))
        ]),
      );

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3;
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.1),
                child: appBarWidget(size, false)),
            backgroundColor: Colors.white,
            bottomNavigationBar:
                BottomNavigationBarScreen(currentIndex: _currentIndex),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My Account",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
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
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
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
                                                    color: Colors.white,
                                                    fontSize: 15),
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
                                  if (!isCustomer)
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 180,
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
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
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ))),
                    ]),
                    SizedBox(height: size.height * 0.03),
                    if (isCustomer)
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'My orders',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: size.height * 0.02),
                              ],
                            ),
                          )
                        ],
                      )
                    else
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.height * 0.03),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'My announcements',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    /*Container(
                                        height: size.height * 0.05,
                                        child: ListView.separated(
                                          padding: EdgeInsets.all(10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: Article()
                                              .currentAnnouncements
                                              .length,
                                          itemBuilder: (context, index) =>
                                              articleBox(Article()
                                                  .currentAnnouncements[index]),
                                          separatorBuilder: (context, _) =>
                                              SizedBox(
                                                  width: size.width * 0.02),
                                        ))*/
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  ],
                ))));
  }
}
