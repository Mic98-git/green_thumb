import 'package:flutter/material.dart';
import 'package:green_thumb/screens/puchase_procedure/confirmation.dart';
import '../../config/global_variables.dart';
import '../../models/article.dart';

class PaymentScreen extends StatefulWidget {
  static String id = "payment_method_screen";
  final String name;
  final String address;
  final String city;
  final double itemsPrice;
  final List<Article> articlesList;
  const PaymentScreen(
      {Key? key,
      required this.name,
      required this.address,
      required this.city,
      required this.itemsPrice,
      required this.articlesList})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = "";

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
                          'Payment >> ',
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
                          this.paymentMethod = "Paypal";
                        });
                      },
                      icon: Icon(
                        Icons.paypal,
                        size: 50,
                        color: this.paymentMethod == "Paypal"
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
                          this.paymentMethod = "Credit card";
                        });
                      },
                      icon: Icon(
                        Icons.credit_card,
                        size: 50,
                        color: this.paymentMethod == "Credit card"
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
                        if (this.paymentMethod != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderConfirmationScreen(
                                      fullname: widget.name,
                                      address: widget.address,
                                      city: widget.city,
                                      totalPrice: widget.itemsPrice,
                                      paymentMethod: this.paymentMethod,
                                      articlesList: widget.articlesList)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: Select one payment method'),
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
