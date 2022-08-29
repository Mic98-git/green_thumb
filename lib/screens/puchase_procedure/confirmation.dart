import 'package:flutter/material.dart';
import 'package:green_thumb/screens/puchase_procedure/credit_card_info.dart';
import '../../config/global_variables.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static String id = "shipping_info_screen";
  final String name;
  final String address;
  final String city;
  const OrderConfirmationScreen(
      {Key? key, required this.name, required this.address, required this.city})
      : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String OrderConfirmationMethod = "";

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
                      'Checkout',
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
                          'Shipping Info >> ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'OrderConfirmation >> ',
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
                    height: size.height * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          this.OrderConfirmationMethod = "paypal";
                        });
                      },
                      icon: Icon(
                        Icons.paypal,
                        size: 50,
                        color: this.OrderConfirmationMethod == "paypal"
                            ? primaryColor
                            : Colors.grey,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Align(
                      child: Row(children: [
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      height: size.height * 0.02,
                      child: Divider(color: Colors.grey),
                    ),
                    Text("  Or pay with  ",
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    SizedBox(
                      width: size.width * 0.3,
                      height: size.height * 0.02,
                      child: Divider(color: Colors.grey),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                  ])),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          this.OrderConfirmationMethod = "credit card";
                        });
                      },
                      icon: Icon(
                        Icons.credit_card,
                        size: 50,
                        color: this.OrderConfirmationMethod == "credit card"
                            ? primaryColor
                            : Colors.grey,
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
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
                        if (this.OrderConfirmationMethod != "") {
                          if (this.OrderConfirmationMethod == "paypal") {
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreditCardInfo()));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Error: Select one OrderConfirmation method'),
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
