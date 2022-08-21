import 'package:flutter/material.dart';
import '../profile_registration/user_registration_completed.dart';
import './announcement_creation_completed.dart';
import '../../colors.dart';

class ArticleReviewScreen extends StatefulWidget {
  static String id = "article_review_screen";
  final String water;
  final String oxygen;
  final String sun;
  final String price;
  final Image image;
  final String fullName;
  final String latinName;
  final String description;
  final String category;
  const ArticleReviewScreen(
      {Key? key,
      required this.water,
      required this.oxygen,
      required this.sun,
      required this.price,
      required this.image,
      required this.fullName,
      required this.latinName,
      required this.description,
      required this.category})
      : super(key: key);

  @override
  State<ArticleReviewScreen> createState() => _ArticleReviewScreenState();
}

class _ArticleReviewScreenState extends State<ArticleReviewScreen> {
  String waterFrequency = "Daily";

  void saveInfo() {
    //check errors or nullable values to eraise dialogs
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserRegistrationCompletedScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ATTENTION"),
      content: Text("Are you sure you want to cancel the procedure?"),
      actions: [
        okButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed: Navigator.of(context).pop,
                  ),
                  TextButton(
                      onPressed: () {
                        showAlertDialog(context);
                      },
                      child: Text(
                        'X Close',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      )),
                ],
              ),
              Center(
                child: Text(
                  'New Article',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('New Article >> ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                    Text(
                      'Details >> ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Confirmation',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
              SizedBox(
                height: size.height * 0.02,
              ),
              Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 160.0,
                        width: 160.0,
                        child: widget.image,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.3),
                    child: Text(
                      widget.fullName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(widget.latinName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  Text('Price: ' + widget.price,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.water_drop_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Text(
                    ' ' + widget.water,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/icons/oxygen.png'),
                      ),
                      Text(
                        '  ' + widget.oxygen + ' grams/day',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.sunny,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  Text(
                    ' ' + widget.sun,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Text(widget.description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ))
              ]),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    saveInfo();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AnnouncementCreationCompletedScreen()));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Post Article',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Icon(Icons.double_arrow_outlined),
                      ]),
                ),
              ),
            ])));
  }
}
