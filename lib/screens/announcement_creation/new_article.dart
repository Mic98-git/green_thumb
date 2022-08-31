import 'package:flutter/material.dart';
import './article_details.dart';
import '../../config/global_variables.dart';
import '../my_account.dart';

class NewArticleScreen extends StatefulWidget {
  static String id = "new_article_screen";
  const NewArticleScreen({Key? key}) : super(key: key);

  @override
  State<NewArticleScreen> createState() => _NewArticleScreenState();
}

class _NewArticleScreenState extends State<NewArticleScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latinNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Map<String, String> formFields = Map();

  int buttonSelected = 1;
  String category = "plant";

  void nextScreen(BuildContext context) async {
    formFields = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) {
        return ArticleDetailsScreen(
            water: formFields["water"] ?? "",
            oxygen: formFields["oxygen"] ?? "",
            sun: formFields["sun"] ?? "",
            price: formFields["price"] ?? "",
            pieces: formFields["pieces"] ?? "",
            fullName: this.nameController.text,
            latinName: this.latinNameController.text,
            description: this.descriptionController.text,
            category: this.category);
      },
    ));
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                        Text(
                          'New Article >> ',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
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
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Article Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Article name",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Latin Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: latinNameController,
                        decoration: InputDecoration(
                          hintText: "Latin name",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: descriptionController,
                        minLines: 1,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Description here',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio(
                                        value: 1,
                                        groupValue: buttonSelected,
                                        onChanged: (int? value) {
                                          setState(() {
                                            buttonSelected = value!.toInt();
                                            category = "plant";
                                          });
                                        }),
                                    Expanded(
                                      child: Text('Plant'),
                                    ),
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio(
                                        value: 2,
                                        groupValue: buttonSelected,
                                        onChanged: (int? value) {
                                          setState(() {
                                            buttonSelected = value!.toInt();
                                            category = "tool";
                                          });
                                        }),
                                    Expanded(child: Text('Tool'))
                                  ],
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                        if (this.nameController.text.isNotEmpty &&
                            this.latinNameController.text.isNotEmpty &&
                            this.descriptionController.text.isNotEmpty) {
                          nextScreen(context);
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
