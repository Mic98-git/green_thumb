import 'package:flutter/material.dart';
import 'package:green_thumb/core/api_client.dart';
import '../../config/global_variables.dart';
import '../my_account.dart';

class OrderCompletedScreen extends StatefulWidget {
  static String id = "order_completed_screen";
  const OrderCompletedScreen({Key? key}) : super(key: key);

  @override
  State<OrderCompletedScreen> createState() => _OrderCompletedScreenState();
}

class _OrderCompletedScreenState extends State<OrderCompletedScreen> {
  final ApiClient _apiClient = ApiClient();

  Future<void> deleteCart(String cartId) async {
    shoppingCartItems.clear(); //clean the local shopping cart
    dynamic res = await _apiClient.deleteCart(cartId);
    if (res['error'] == null) {
      print(res);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text(
                    'Order sent',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                          'assets/images/registration_completed.png')),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Dear " +
                              user.fullname +
                              ", thank you for buying on GreenThumb! Your order has been sent. It will arrive at the specified address as soon as possible",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )))),
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
                    deleteCart(user.userId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAccountScreen()));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'My Account ',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Icon(
                          Icons.account_circle_outlined,
                          size: 30,
                        ),
                      ]),
                ),
              ),
            ])));
  }
}
