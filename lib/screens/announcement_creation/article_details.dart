import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../profile_registration/user_registration_completed.dart';
import './article_review.dart';
import '../../colors.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static String id = "article_details_screen";
  final String fullName;
  final String latinName;
  final String description;
  final String category;
  const ArticleDetailsScreen(
      {Key? key,
      required this.fullName,
      required this.latinName,
      required this.description,
      required this.category})
      : super(key: key);

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final TextEditingController lightController = TextEditingController();
  final TextEditingController oxygenController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Image? articleImage;
  late String imagePath;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Daily"), value: "Daily"),
      DropdownMenuItem(child: Text("Weekly"), value: "Weekly"),
      DropdownMenuItem(child: Text("When dry"), value: "When dry"),
    ];
    return menuItems;
  }

  String waterFrequency = "Daily";

  void pickImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      imagePath = file.path;
      setState(() {
        this.articleImage = Image.file(File(imagePath));
      });
    } else
      return;
  }

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
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Confirmation',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ]),
              SizedBox(
                height: size.height * 0.04,
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
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                      value: waterFrequency,
                      onChanged: (String? newValue) {
                        setState(() {
                          waterFrequency = newValue!;
                        });
                      },
                      items: dropdownItems),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
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
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child: TextFormField(
                      controller: oxygenController,
                      decoration: InputDecoration(
                        hintText: "Grams/day",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.sunny,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child: TextFormField(
                      controller: lightController,
                      decoration: InputDecoration(
                        hintText: "Light info",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.euro,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    child: TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: "Price",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.add_a_photo,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 250,
                      height: 50,
                      child: TextButton(
                        child: Text('Pick image from gallery *',
                            style: TextStyle(fontSize: 20)),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          pickImage();
                        },
                      )),
                  if (this.articleImage != null)
                    Icon(
                      Icons.verified,
                      color: primaryColor,
                    ),
                ],
              ),
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
                    if (this.oxygenController.text.isNotEmpty &&
                        this.lightController.text.isNotEmpty &&
                        this.priceController.text.isNotEmpty &&
                        this.articleImage != null) {
                      saveInfo();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleReviewScreen(
                                    water: this.waterFrequency,
                                    oxygen: this.oxygenController.text,
                                    sun: this.lightController.text,
                                    price: this.priceController.text,
                                    image: this.articleImage!,
                                    fullName: widget.fullName,
                                    latinName: widget.latinName,
                                    description: widget.description,
                                    category: widget.category,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: Complete all the requested data'),
                        backgroundColor: Colors.red.shade300,
                      ));
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Icon(Icons.double_arrow_outlined),
                      ]),
                ),
              ),
            ])));
  }
}