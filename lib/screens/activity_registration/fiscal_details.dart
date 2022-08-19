import 'package:flutter/material.dart';
import './activity_registration_completed.dart';
import '../../colors.dart';

class FiscalDetailsScreen extends StatefulWidget {
  static String id = "fiscal_details_screen";
  const FiscalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FiscalDetailsScreen> createState() => _FiscalDetailsScreenState();
}

class _FiscalDetailsScreenState extends State<FiscalDetailsScreen> {
  final TextEditingController VATController = TextEditingController();
  final TextEditingController IBANController = TextEditingController();

  void saveInfo() {
    //check errors or nullable values to eraise dialogs
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text(
                'Your activity',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'Activity Info >> ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Text(
              'Fiscal Details',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
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
                "VAT Number",
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
                controller: VATController,
                decoration: InputDecoration(
                  hintText: "VAT number",
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
                "IBAN Code",
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
                controller: IBANController,
                decoration: InputDecoration(
                  hintText: "IBAN code",
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
                color: primaryColor, borderRadius: BorderRadius.circular(20)),
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
                            const ActivityRegistrationCompletedScreen()));
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
        ]));
  }
}