import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/screens/puchase_procedure/order_completed.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatelessWidget {
  final double amount;
  final String currency;
  final String userId, fullname, address, city;

  const PaypalPayment({
    Key? key,
    required this.amount,
    required this.currency,
    required this.userId,
    required this.fullname,
    required this.address,
    required this.city,
  }) : super(key: key);

  Future<void> addOrder() async {
    final ApiClient _apiClient = ApiClient();

    Map<String, dynamic> orderData = {
      'userId': this.userId,
      'fullname': this.fullname,
      'address': this.address,
      'city': this.city,
      'payment': 'paypal',
      'cart': shoppingCartRequest,
      'total': this.amount
    };
    dynamic res = await _apiClient.addOrder(this.userId, orderData);

    if (res['error'] == null) {
    } else {
      print(res['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: WebView(
        initialUrl: url + ':3003/pay/create?amount=$amount&currency=$currency',
        javascriptMode: JavascriptMode.unrestricted,
        gestureRecognizers: Set()
          ..add(Factory<DragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
        onPageFinished: (value) {
          print(value);
        },
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.contains('http://return_url/?status=success')) {
            addOrder();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderCompletedScreen()));
          }
          if (request.url.contains('http://cancel_url')) {
            Navigator.pop(context);
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
