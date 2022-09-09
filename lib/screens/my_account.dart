import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/models/order.dart';
import 'package:green_thumb/screens/order_page.dart';
import 'package:green_thumb/screens/tracking/user_tracking.dart';
import 'package:green_thumb/widgets/app_bar.dart';
import 'package:green_thumb/widgets/navigation_bar.dart';
import './announcement_creation/new_article.dart';
import 'article_page.dart';
import '../models/article.dart';
import '../core/api_client.dart';
import '../models/articleList.dart';
import 'package:green_thumb/screens/edit_profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyAccountScreen extends StatefulWidget {
  static String id = "my_account_screen";
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Article> myArticles = [];
  List<Order> customerOrders = [];
  List<Order> sellerPendingOrders = [];
  List<Order> sellerCompletedOrders = [];
  bool checkAnnouncements = false;
  bool checkSellerPendingOrders = false;
  bool checkSellerCompletedOrders = false;
  bool checkCustomerOrders = false;
  Image profileImage = Image.asset('assets/images/image.png');
  Image pendingOrder = Image.asset('assets/icons/pending_order.png');
  Image orderCompleted = Image.asset('assets/icons/order_completed.png');
  int sellerRating = 0;
  int orderRating = 0;

  @override
  void initState() {
    super.initState();
    if (!user.isCustomer) {
      this.getSellersAnnouncements(user.userId);
    }
    this.getOrders(user.userId, user.isCustomer);
    if (user.ratingValue > 0 && user.numberOfRatings > 0)
      setState(() {
        sellerRating = (user.ratingValue / user.numberOfRatings).round();
      });
  }

  Future<void> rateOrder(Order order, int ratingValue) async {
    dynamic res =
        await _apiClient.rateOrder(order.orderId, ratingValue.toString());
    if (res['error'] == null) {
      List<String> orderIds = [];
      for (var p in order.cart) {
        orderIds.add(p.sellerId);
      }
      dynamic res1 = await _apiClient.rateUsers(orderIds, ratingValue);
      if (res1['error'] == null) {
        print(res1);
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

  Future<void> getOrders(String userId, bool isCustomer) async {
    dynamic res;
    if (isCustomer)
      res = await _apiClient.getUserOrders(user.userId);
    else
      res = await _apiClient.getSellerOrders(user.userId);
    if (res['error'] == null) {
      for (var o in res['orders']) {
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
          Order newOrder = new Order(
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
          if (newOrder.delivered)
            sellerCompletedOrders.add(newOrder);
          else
            sellerPendingOrders.add(newOrder);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${res1['error']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
      customerOrders.addAll(sellerCompletedOrders);
      customerOrders.addAll(sellerPendingOrders);
      setState(() {
        customerOrders = customerOrders.reversed.toList();
        this.checkSellerPendingOrders = true;
        this.checkSellerCompletedOrders = true;
        this.checkCustomerOrders = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> getSellersAnnouncements(String userId) async {
    dynamic res = await _apiClient.getSellersProducts(userId);
    articleList articles = new articleList(res);
    setState(() {
      this.myArticles = articles.list;
      this.checkAnnouncements = true;
    });
  }

  void showArticleDetails(Article a) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ArticleScreen(article: a)));
  }

  void showOrderDetails(Order o) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderScreen(order: o)))
        .then((_) => _pullRefresh());
  }

  void trackOrder(String orderId) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPositionScreen(orderId)))
        .then((_) => _pullRefresh());
  }

  Widget buildRating(Size size) => RatingBar.builder(
        initialRating: 0,
        minRating: 1,
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: 25,
        itemPadding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        itemBuilder: (context, _) => Image.asset('assets/icons/leaf.png'),
        onRatingUpdate: (rating) {
          setState(() {
            this.orderRating = rating.toInt();
          });
        },
      );

  showRatingDialog(Size size, Order order) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Rating"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Please help us improve the service leaving a rating to your order',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.04),
                buildRating(size),
              ],
            ),
            actions: [
              TextButton(
                  child: Text('Ok', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    this.rateOrder(order, orderRating).then((_) {
                      _pullRefresh();
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    });
                  })
            ],
          ));

  Widget sellerArticleBox({required Article item, required Size size}) =>
      Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Container(
                width: size.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                        child: Ink.image(
                      image: item.picture.image,
                      fit: BoxFit.cover,
                      child: InkWell(
                        onTap: () {
                          showArticleDetails(item);
                        },
                      ),
                    )),
                  ),
                )),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
              width: size.width * 0.35,
              height: size.height * 0.1,
              child: GestureDetector(
                  onTap: () {
                    showArticleDetails(item);
                  },
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 18),
                  )))
        ]),
      );

  Widget sellerOrderBox(
          {required Order order, required Size size, required bool pending}) =>
      Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Container(
                width: size.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                        child: Ink.image(
                      image: pending
                          ? this.pendingOrder.image
                          : this.orderCompleted.image,
                      fit: BoxFit.contain,
                      child: InkWell(
                        onTap: () {
                          showOrderDetails(order);
                        },
                      ),
                    )),
                  ),
                )),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
              width: size.width * 0.35,
              height: size.height * 0.1,
              child: GestureDetector(
                  onTap: () {
                    showOrderDetails(order);
                  },
                  child: Text(
                    'Order ' +
                        ((order.orderId.replaceAll(RegExp('[a-zA-Z]'), ''))
                            .substring(0, 8)),
                    style: TextStyle(fontSize: 18),
                  ))),
        ]),
      );

  Widget customerOrderArticleBox(
          {required Article article, required Size size}) =>
      Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: size.height * 0.10,
            width: size.width * 0.20,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FittedBox(
                    child: article.picture,
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
                Row(children: [
                  Container(
                    child: Text(
                      article.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: size.height * 0.005),
                Row(children: [
                  Icon(Icons.store, color: Colors.grey, size: 18),
                  Text(
                    ' ' + article.sellerName,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ])
              ])
        ])
      ]));

  Widget customerOrderBox({required Order order, required Size size}) =>
      Container(
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.001, horizontal: size.width * 0.03),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor, width: 1)),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => showOrderDetails(order),
                            child: Text(
                              'Order ' +
                                  ((order.orderId
                                          .replaceAll(RegExp('[a-zA-Z]'), ''))
                                      .substring(0, 8)),
                              style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          if (!order.delivered)
                            TextButton(
                                onPressed: () {
                                  trackOrder(order.orderId);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: Text("Track order",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.normal)))
                          else if (order.ratingValue > 0)
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02),
                                child: Row(children: [
                                  for (int i = 0; i < order.ratingValue; i++)
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child:
                                          Image.asset('assets/icons/leaf.png'),
                                    )
                                ]))
                          else
                            TextButton(
                                onPressed: () {
                                  showRatingDialog(size, order);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: Text("Rate order",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.normal)))
                        ],
                      ),
                      order.cart.isNotEmpty
                          ? Container(
                              child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: order.cart.length,
                              itemBuilder: (context, index) =>
                                  customerOrderArticleBox(
                                      article: order.cart[index], size: size),
                              separatorBuilder: (context, _) =>
                                  SizedBox(height: size.height * 0.02),
                            ))
                          : Row(children: [
                              Text("Products info not available!",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red))
                            ]),
                      SizedBox(height: size.height * 0.01)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ]),
                      SizedBox(height: size.height * 0.01),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Icon(Icons.euro, size: 18),
                        Text(
                          order.total.toStringAsFixed(2),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ]),
                      SizedBox(height: size.height * 0.015),
                    ],
                  )
                ],
              )),
        ]),
      );

  Future<void> _pullRefresh() async {
    this.myArticles.clear();
    this.sellerPendingOrders.clear();
    this.sellerCompletedOrders.clear();
    this.customerOrders.clear();
    this.checkAnnouncements = false;
    this.checkSellerPendingOrders = false;
    this.checkSellerCompletedOrders = false;
    this.checkCustomerOrders = false;
    if (!user.isCustomer) {
      this.getSellersAnnouncements(user.userId);
    }
    this.getOrders(user.userId, user.isCustomer);
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3;
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.09),
                child: appBarWidget(size, false)),
            backgroundColor: Colors.white,
            bottomNavigationBar:
                BottomNavigationBarScreen(currentIndex: _currentIndex),
            body: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "My Account",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: size.height * 0.11,
                            child: CircleAvatar(
                              radius: size.height * 0.1,
                              backgroundImage: profileImage.image,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.01,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.20,
                                        maxWidth: size.width * 0.25),
                                    child: Text(
                                      user.fullname,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  if (!user.isCustomer)
                                    for (int i = 0; i < this.sellerRating; i++)
                                      Container(
                                        width: 15,
                                        height: 15,
                                        child: Image.asset(
                                            'assets/icons/leaf.png'),
                                      ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.02),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.01,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 85,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfileScreen()));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Edit ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.02),
                              if (!user.isCustomer)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NewArticleScreen()));
                                        },
                                        child: Text(
                                          'New Announcement',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: size.height * 0.03),
                  if (user.isCustomer)
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'My orders',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: size.height * 0.03),
                            ],
                          ),
                        ),
                        this.customerOrders.isEmpty && checkCustomerOrders
                            ? Column(children: [
                                SizedBox(height: size.height * 0.09),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.1),
                                    child: Text('No order placed!',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey))),
                                SizedBox(height: size.height * 0.09)
                              ])
                            : Column(
                                children: [
                                  SizedBox(height: size.height * 0.02),
                                  Container(
                                      child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.02),
                                    itemCount: this.customerOrders.length,
                                    itemBuilder: (context, index) =>
                                        customerOrderBox(
                                            order: this.customerOrders[index],
                                            size: size),
                                    separatorBuilder: (context, _) =>
                                        SizedBox(height: size.height * 0.015),
                                  )),
                                  SizedBox(height: size.height * 0.04),
                                ],
                              )
                      ],
                    )
                  else
                    Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'My announcements',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      myArticles.isEmpty && checkAnnouncements
                          ? Column(children: [
                              SizedBox(height: size.height * 0.09),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.1),
                                  child: Text(
                                      'No announcement posted. Create your first one!',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey))),
                              SizedBox(height: size.height * 0.09)
                            ])
                          : Column(
                              children: [
                                SizedBox(height: size.height * 0.02),
                                Container(
                                    height: size.height * 0.3,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.05),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: this.myArticles.length,
                                      itemBuilder: (context, index) =>
                                          sellerArticleBox(
                                              item: this.myArticles[index],
                                              size: size),
                                      separatorBuilder: (context, _) =>
                                          SizedBox(width: size.width * 0.05),
                                    )),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Pending orders',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      this.sellerPendingOrders.isEmpty &&
                              checkSellerPendingOrders
                          ? Column(children: [
                              SizedBox(height: size.height * 0.09),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.1),
                                  child: Text('No pending orders. Good job!',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey))),
                              SizedBox(height: size.height * 0.09)
                            ])
                          : Column(children: [
                              SizedBox(height: size.height * 0.03),
                              Container(
                                  height: size.height * 0.3,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.05),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: this.sellerPendingOrders.length,
                                    itemBuilder: (context, index) =>
                                        sellerOrderBox(
                                            order:
                                                this.sellerPendingOrders[index],
                                            size: size,
                                            pending: true),
                                    separatorBuilder: (context, _) =>
                                        SizedBox(width: size.width * 0.05),
                                  )),
                            ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Completed orders',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      this.sellerCompletedOrders.isEmpty &&
                              checkSellerCompletedOrders
                          ? Column(children: [
                              SizedBox(height: size.height * 0.09),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.1),
                                  child: Text(
                                      'No order has been completed. Please check your pending list!',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey))),
                              SizedBox(height: size.height * 0.09)
                            ])
                          : Column(children: [
                              SizedBox(height: size.height * 0.03),
                              Container(
                                  height: size.height * 0.3,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.05),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        this.sellerCompletedOrders.length,
                                    itemBuilder: (context, index) =>
                                        sellerOrderBox(
                                            order: this
                                                .sellerCompletedOrders[index],
                                            size: size,
                                            pending: false),
                                    separatorBuilder: (context, _) =>
                                        SizedBox(width: size.width * 0.05),
                                  )),
                            ]),
                    ]),
                ]),
              ),
            )));
  }
}
