import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/models/article.dart';
import 'package:green_thumb/models/order.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/app_bar.dart';

class OrderScreen extends StatefulWidget {
  static String id = "order_screen";
  final Order order;
  OrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ApiClient _apiClient = ApiClient();

  String orderStatus = "";
  late Order currentOrder;
  bool orderInitialized = false;

  @override
  void initState() {
    super.initState();
    this.getOrderInfo(widget.order.orderId).then((_) {
      if (this.mounted)
        setState(() {
          if (widget.order.delivered) {
            this.orderStatus = "order delivered";
          } else {
            if (widget.order.deliveryInProgress) {
              this.orderStatus = "complete delivery";
            } else {
              this.orderStatus = "start delivery";
            }
          }
        });
    });
  }

  Future<void> updateOrderStatus(String orderId) async {
    await this.getOrderInfo(orderId);
  }

  Future<void> getOrderInfo(String orderId) async {
    dynamic res = await _apiClient.getOrder(orderId);
    if (res['error'] == null) {
      var o = res['order'];
      List<String> products = [];
      List<Article> orderArticles = [];
      for (var i in o['cart']) {
        products.add(i['productId']);
      }
      dynamic res1 = await _apiClient.getProductsByList(products);
      if (res1['error'] == null) {
        for (var a in res1['products']) {
          final base64String = a['picture'];
          Image articleImage = Image.memory(base64Decode(base64String));
          orderArticles.add(new Article(
              a['_id'],
              a['sellerId'],
              a['sellerName'],
              a['name'],
              a['latin'],
              a['description'],
              a['category'],
              a['water'],
              a['oxygen'].toString(),
              a['sunlight'],
              a['price'].toString(),
              articleImage,
              a['quantityStock'].toString()));
        }
        currentOrder = new Order(
            orderId: o['_id'],
            userId: o['userId'],
            fullname: o['fullname'],
            address: o['address'],
            city: o['city'],
            payment: o['payment'],
            cart: orderArticles,
            total: o['total'].toDouble(),
            latitude: o['latitude'].toDouble(),
            longitude: o['longitude'].toDouble(),
            createdAt: o['created_at'],
            delivered: o['delivered'],
            deliveryInProgress: o['deliveryInProgress'],
            ratingValue: o['ratingValue']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res1['error']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> deliveryInProgress(String orderId) async {
    dynamic res = await _apiClient.deliveryInProgress(orderId);
    if (res['error'] == null) {
      updateOrderStatus(orderId).then((_) => setState(() {
            this.orderStatus = "complete delivery";
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> deliveryCompleted(String orderId) async {
    dynamic res = await _apiClient.deliveredOrder(orderId);
    if (res['error'] == null) {
      updateOrderStatus(orderId).then((_) => setState(() {
            this.orderStatus = "order delivered";
          }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<Position> startOrderDelivery(String orderId) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final ApiClient apiClient = ApiClient();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');

      Map<String, dynamic> body = {
        "latitude": position?.latitude,
        "longitude": position?.longitude
      };

      await apiClient.updatePosition(body, orderId);
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

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
                      double.parse(item.price).toStringAsFixed(2),
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
    if (!orderInitialized) {
      this.currentOrder = widget.order;
      this.orderInitialized = true;
    }
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
              !user.isCustomer
                  ? !currentOrder.delivered
                      ? currentOrder.deliveryInProgress
                          ? Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  print("completing order");
                                  deliveryCompleted(widget.order.orderId);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(this.orderStatus,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  print("delivering order");
                                  startOrderDelivery(widget.order.orderId).then(
                                      (_) => deliveryInProgress(
                                          widget.order.orderId));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(this.orderStatus,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(this.orderStatus,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500))))
                  : !currentOrder.delivered
                      ? currentOrder.deliveryInProgress
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('order shipped',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500))))
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('order not yet shipped',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500))))
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
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
              if (!user.isCustomer)
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
                                          itemBuilder: (context, index) =>
                                              items(
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
                                                fontSize: 18,
                                                color: Colors.red))
                                      ]),
                              ]))))
                ]),
            ])));
  }
}

/*SizedBox(height: size.height * 0.03),*/