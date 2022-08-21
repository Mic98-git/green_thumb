import 'package:flutter/material.dart';
import './fiscal_details.dart';
import '../profile_registration/user_registration_completed.dart';
import '../../colors.dart';

class ActivityInfoScreen extends StatefulWidget {
  static String id = "activity_info_screen";
  const ActivityInfoScreen({Key? key}) : super(key: key);

  @override
  State<ActivityInfoScreen> createState() => _ActivityInfoScreenState();
}

class _ActivityInfoScreenState extends State<ActivityInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController fiscalAddressController = TextEditingController();

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
                  'Your activity',
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
                      'Activity Info >> ',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Fiscal Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ]),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Activity Name",
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
                      hintText: "Activity name",
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
                    "Fiscal Address",
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
                    controller: fiscalAddressController,
                    decoration: InputDecoration(
                      hintText: "Fiscal address",
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
                    "City",
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
                    controller: cityController,
                    decoration: InputDecoration(
                      hintText: "City",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
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
                            builder: (context) => const FiscalDetailsScreen()));
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
