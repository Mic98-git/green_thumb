import 'package:flutter/material.dart';
import 'package:green_thumb/screens/puchase_procedure/credit_card_info.dart';
import 'package:green_thumb/screens/puchase_procedure/paypal.dart';
import '../../config/global_variables.dart';
import '../../models/article.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static String id = "shipping_info_screen";
  final String fullname;
  final String address;
  final String city;
  final double totalPrice;
  final String paymentMethod;
  final List<Article> articlesList;
  const OrderConfirmationScreen(
      {Key? key,
      required this.fullname,
      required this.address,
      required this.city,
      required this.totalPrice,
      required this.paymentMethod,
      required this.articlesList})
      : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
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

  Widget items({required Article item, required Size size}) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.15,
              width: size.width * 0.25,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FittedBox(
                      child: item.picture,
                      fit: BoxFit.cover,
                    )),
              ),
              decoration: BoxDecoration(
                  color: articleBoxColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(width: size.width * 0.03),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.5,
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Price: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.euro, size: 20),
                      Text(
                        item.price,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: backgroundColor,
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
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.03),
                        child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.03,
                                    horizontal: size.width * 0.03),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ship to",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.fullname,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      ]),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.address,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      ]),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.city,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      ]),
                                ]))))
                  ]),
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                        ),
                        child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.03,
                                    horizontal: size.width * 0.03),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pay with",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.paymentMethod + ' ',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        widget.paymentMethod == "Paypal"
                                            ? Icon(Icons.paypal)
                                            : Icon(
                                                Icons.credit_card,
                                              )
                                      ]),
                                ]))))
                  ]),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                        ),
                        child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.03,
                                    horizontal: size.width * 0.03),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Articles",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                  Column(children: [
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: shoppingCartItems.length,
                                      itemBuilder: (context, index) => items(
                                        item: widget.articlesList[index],
                                        size: size,
                                      ),
                                      separatorBuilder: (context, _) =>
                                          SizedBox(height: size.height * 0.02),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.8,
                                      height: size.height * 0.08,
                                      child: Divider(color: primaryColor),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.05),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Shipping included",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.euro, size: 25),
                                                Text(
                                                  widget.totalPrice
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ])
                                ]))))
                  ]),
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
                        if (widget.paymentMethod == "Paypal") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaypalPayment(
                                  amount: double.parse(
                                      widget.totalPrice.toStringAsFixed(2)),
                                  currency: 'EUR',
                                  userId: user.userId,
                                  fullname: widget.fullname,
                                  address: widget.address,
                                  city: widget.city,
                                ),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreditCardInfo(
                                        amount: double.parse(widget.totalPrice
                                            .toStringAsFixed(2)),
                                        currency: 'EUR',
                                        userId: user.userId,
                                        fullname: widget.fullname,
                                        address: widget.address,
                                        city: widget.city,
                                      )));
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Buy ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                ]))));
  }
}
