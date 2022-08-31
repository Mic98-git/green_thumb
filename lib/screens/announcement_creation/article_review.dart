import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import './announcement_creation_completed.dart';
import '../../config/global_variables.dart';
import '../my_account.dart';

class ArticleReviewScreen extends StatefulWidget {
  static String id = "article_review_screen";
  final String water;
  final String oxygen;
  final String sun;
  final String price;
  final String pieces;
  final Image image;
  final String imageString;
  final String fullName;
  final String latinName;
  final String description;
  final String category;
  const ArticleReviewScreen(
      {Key? key,
      required this.water,
      required this.oxygen,
      required this.sun,
      required this.pieces,
      required this.price,
      required this.image,
      required this.imageString,
      required this.fullName,
      required this.latinName,
      required this.description,
      required this.category})
      : super(key: key);

  @override
  State<ArticleReviewScreen> createState() => _ArticleReviewScreenState();
}

class _ArticleReviewScreenState extends State<ArticleReviewScreen> {
  final ApiClient _apiClient = ApiClient();

  Future<void> saveInfo() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));
    //todo manage errors
    Map<String, dynamic> articleData = {
      'sellerId': user.userId,
      'sellerName': user.fullname,
      'name': widget.fullName,
      'latin': widget.latinName,
      'description': widget.description,
      'category': widget.category,
      'water': widget.water,
      'oxygen': widget.oxygen,
      'sunlight': widget.sun,
      'price': widget.price,
      'picture': widget.imageString,
      'quantity': widget.pieces,
    };

    dynamic res = await _apiClient.addNewProduct(articleData);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (res['ErrorCode'] == null) {
      //product added
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const AnnouncementCreationCompletedScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['Message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyAccountScreen()));
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
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
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
                    height: size.height * 0.05,
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: size.height * 0.20,
                            width: size.width * 0.35,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FittedBox(
                                    child: widget.image,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            decoration: BoxDecoration(
                                color: articleBoxColor,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      Container(
                          width: size.width * 0.6,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                widget.fullName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Price: ' + widget.price,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Icon(Icons.euro),
                                ],
                              ),
                              SizedBox(height: size.height * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Available items: ' + widget.pieces,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
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
                    height: size.height * 0.04,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(widget.description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ))),
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
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        saveInfo();
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Post Article ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ]),
                    ),
                  ),
                ]))));
  }
}
