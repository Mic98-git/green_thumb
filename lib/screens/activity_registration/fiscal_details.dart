import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import './activity_registration_completed.dart';
import '../../config/global_variables.dart';

class FiscalDetailsScreen extends StatefulWidget {
  static String id = "fiscal_details_screen";
  final String activityName;
  final String fiscalAddress;
  final String city;
  final String vat;
  final String iban;
  const FiscalDetailsScreen(
      {Key? key,
      required this.activityName,
      required this.fiscalAddress,
      required this.city,
      required this.vat,
      required this.iban})
      : super(key: key);

  @override
  State<FiscalDetailsScreen> createState() => _FiscalDetailsScreenState();
}

class _FiscalDetailsScreenState extends State<FiscalDetailsScreen> {
  final TextEditingController VATController = TextEditingController();
  final TextEditingController IBANController = TextEditingController();

  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    print(widget.vat);
    if (widget.vat != "") {
      this.VATController.text = widget.vat;
    }
    if (widget.iban != "") {
      this.IBANController.text = widget.iban;
    }
  }

  Future<void> updateFiscalDetails() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));

    Map<String, dynamic> userData = {
      "activityName": widget.activityName,
      "fiscalAddress": widget.fiscalAddress,
      "city": widget.city,
      "vatNumber": VATController.text,
      "ibanCode": IBANController.text,
    };

    dynamic res = await _apiClient.updateUser(registeredUserId, userData);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (res['error'] == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActivityRegistrationCompletedScreen(
                    activityName: widget.activityName,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
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
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pop();
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
                            "vat": this.VATController.text,
                            "iban": this.IBANController.text
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
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        if (this.VATController.text.isNotEmpty &&
                            this.IBANController.text.isNotEmpty) {
                          updateFiscalDetails();
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
