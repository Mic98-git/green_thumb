import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import './article_review.dart';
import '../../config/global_variables.dart';
import '../my_account.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static String id = "article_details_screen";
  final String fullName;
  final String latinName;
  final String description;
  final String category;
  final String water;
  final String oxygen;
  final String sun;
  final String price;
  final String pieces;
  const ArticleDetailsScreen({
    Key? key,
    required this.fullName,
    required this.latinName,
    required this.description,
    required this.category,
    required this.water,
    required this.oxygen,
    required this.sun,
    required this.price,
    required this.pieces,
  }) : super(key: key);

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final TextEditingController lightController = TextEditingController();
  final TextEditingController oxygenController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availablePiecesController =
      TextEditingController();

  Image? articleImage;
  String? imageString;
  String imagePath = "";
  String waterFrequency = "Daily";

  @override
  void initState() {
    super.initState();
    if (widget.water != "") {
      this.waterFrequency = widget.water;
    }
    if (widget.oxygen != "") {
      this.oxygenController.text = widget.oxygen;
    }

    if (widget.sun != "") {
      this.lightController.text = widget.sun;
    }

    if (widget.price != "") {
      this.priceController.text = widget.price;
    }

    if (widget.pieces != "") {
      this.availablePiecesController.text = widget.pieces;
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Daily"), value: "Daily"),
      DropdownMenuItem(child: Text("Weekly"), value: "Weekly"),
      DropdownMenuItem(child: Text("When dry"), value: "When dry"),
    ];
    return menuItems;
  }

  void pickImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      imagePath = file.path;
      File imageFile = File(imagePath);
      Uint8List bytes = await imageFile.readAsBytes();
      String base64Image = base64.encode(bytes);
      setState(() {
        this.articleImage = Image.file(imageFile);
        this.imageString = base64Image;
      });
    } else
      return;
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
                        onPressed: () {
                          Navigator.of(context).pop({
                            "water": this.waterFrequency,
                            "oxygen": this.oxygenController.text,
                            "sun": this.lightController.text,
                            "price": this.priceController.text,
                            "pieces": this.availablePiecesController.text,
                          });
                        },
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
                    height: size.height * 0.03,
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
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'water frequency',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Oxygen production",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'grams/day',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
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
                            hintText: "Sunlight exposition",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Price",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
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
                        child: Image.asset('assets/icons/leaf.png'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        child: TextFormField(
                          controller: availablePiecesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Available pieces",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
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
                    height: size.height * 0.03,
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
                        if (this.oxygenController.text.isNotEmpty &&
                            this.lightController.text.isNotEmpty &&
                            this.priceController.text.isNotEmpty &&
                            this.availablePiecesController.text.isNotEmpty &&
                            this.articleImage != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleReviewScreen(
                                        water: this.waterFrequency,
                                        oxygen: this.oxygenController.text,
                                        sun: this.lightController.text,
                                        price: this.priceController.text,
                                        pieces:
                                            this.availablePiecesController.text,
                                        image: this.articleImage!,
                                        imageString: this.imageString!,
                                        fullName: widget.fullName,
                                        latinName: widget.latinName,
                                        description: widget.description,
                                        category: widget.category,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Error: Complete all the requested data'),
                            backgroundColor: Colors.red.shade300,
                          ));
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Confirm ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            Icon(Icons.double_arrow_outlined),
                          ]),
                    ),
                  ),
                ]))));
  }
}
