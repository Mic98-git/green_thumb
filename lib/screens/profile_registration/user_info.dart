import 'package:flutter/material.dart';
import './access_params.dart';
import '../login_page.dart';
import '../../config/global_variables.dart';

class UserInfoScreen extends StatefulWidget {
  static String id = "user_info_screen";
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController fiscalCodeController = TextEditingController();
  bool isCustomer = true;
  late DateTime birthDate;
  Map<String, String> formFields = Map();

  void nextScreen(BuildContext context) async {
    formFields = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) {
        return AccessParamsScreen(
          email: formFields["email"] ?? "",
          password: formFields["password"] ?? "",
          isCustomer: this.isCustomer,
          name: this.nameController.text,
          birthDate: this.birthDateController.text,
          fiscalCode: this.fiscalCodeController.text,
        );
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
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                      'About You',
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
                          'Personal Info >> ',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Access Parameters',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'I am a customer',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: isCustomer ? FontWeight.bold : null),
                        ),
                        Switch(
                          value: !isCustomer,
                          onChanged: (value) {
                            setState(() {
                              isCustomer = !value;
                            });
                          },
                        ),
                        Text(
                          'I am a seller',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: !isCustomer ? FontWeight.bold : null),
                        ),
                      ]),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Full Name",
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
                          hintText: "Name",
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
                        "Birth Date (dd/mm/yyyy)",
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
                        controller: birthDateController,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              if (datePick != null) {
                                setState(() {
                                  this.birthDate = datePick;
                                });
                                final date =
                                    "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                                birthDateController.value = birthDateController
                                    .value
                                    .copyWith(text: date);
                              }
                            },
                            child: Icon(
                              Icons.calendar_month_sharp,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: "dd/mm/yyyy",
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
                        "Fiscal Code",
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
                        controller: fiscalCodeController,
                        decoration: InputDecoration(
                          hintText: "Fiscal Code",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.04,
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
                            this.birthDateController.text.isNotEmpty &&
                            this.fiscalCodeController.text.isNotEmpty) {
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
                              'Continue ',
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
