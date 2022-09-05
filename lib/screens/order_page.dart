import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/models/article.dart';
import 'package:green_thumb/models/order.dart';
import '../widgets/app_bar.dart';

class OrderScreen extends StatefulWidget {
  static String id = "order_screen";
  final Order order;
  const OrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void startOrderDelivery() {}

  Widget items({required Article item, required Size size}) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/icons/leaf.png'),
                    ),
                  ])
                ]),
            SizedBox(width: size.width * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
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
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.09),
            child: appBarWidget(size, true)),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Order N.' +
                      (widget.order.orderId.replaceAll(RegExp('[a-zA-Z]'), ''))
                          .substring(0, 8),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              !widget.order.delivered
                  ? Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: startOrderDelivery,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text('start delivery',
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: primaryColor)),
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text('order delivered',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500)))),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.fullname,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                  ]),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.address,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                  ]),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.city,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order date",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.createdAt.substring(8, 10) +
                                          '-' +
                                          widget.order.createdAt
                                              .substring(5, 7) +
                                          '-' +
                                          widget.order.createdAt
                                              .substring(0, 4),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ]),
                            ]))))
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
                                vertical: size.height * 0.02,
                                horizontal: size.width * 0.03),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Articles",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                              SizedBox(height: size.height * 0.02),
                              widget.order.cart.isNotEmpty
                                  ? Column(children: [
                                      ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: widget.order.cart.length,
                                        itemBuilder: (context, index) => items(
                                          item: widget.order.cart[index],
                                          size: size,
                                        ),
                                        separatorBuilder: (context, _) =>
                                            SizedBox(
                                                height: size.height * 0.02),
                                      ),
                                    ])
                                  : Row(children: [
                                      Text("Products info not available!",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.red))
                                    ]),
                            ]))))
              ]),
            ])));
  }
}