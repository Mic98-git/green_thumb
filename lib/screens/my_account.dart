import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/models/order.dart';
import 'package:green_thumb/widgets/app_bar.dart';
import 'package:green_thumb/widgets/navigation_bar.dart';
import './announcement_creation/new_article.dart';
import 'article_page.dart';
import '../models/article.dart';
import '../core/api_client.dart';
import '../models/articleList.dart';
import 'package:green_thumb/screens/edit_profile.dart';

class MyAccountScreen extends StatefulWidget {
  static String id = "my_account_screen";
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Article> myArticles = [];
  List<Order> pendingOrders = [];
  List<Order> completedOrders = [];
  bool checkAnnouncements = false;
  bool checkPendingOrders = false;
  bool checkCompletedOrders = false;
  Image profileImage = Image.asset('assets/images/image.png');
  Image pendingOrder = Image.asset('assets/icons/pending_order.png');
  Image orderCompleted = Image.asset('assets/icons/order_completed.png');

  @override
  void initState() {
    super.initState();
    if (!user.isCustomer) {
      this.getSellersAnnouncements(user.userId);
    }
    this.getOrders(user.userId, user.isCustomer);
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
              total: o['total'],
              latitude: o['latitude'].toDouble(),
              longitude: o['longitude'].toDouble(),
              createdAt: o['created_at'],
              delivered: o['delivered']);
          if (newOrder.delivered)
            completedOrders.add(newOrder);
          else
            pendingOrders.add(newOrder);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${res1['error']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
      setState(() {
        this.checkPendingOrders = true;
        this.checkCompletedOrders = true;
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
            MaterialPageRoute(builder: (context) => ArticleScreen(article: a)))
        .then((_) {
      setState(() {});
    });
  }

  void showOrderDetails(Order o) {}

  Widget articleBox({required Article item, required Size size}) => Container(
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
          SizedBox(height: size.height * 0.02),
          Container(
              width: size.width * 0.35,
              height: size.height * 0.1,
              child: GestureDetector(
                  onTap: () {
                    showArticleDetails(item);
                  },
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 20),
                  )))
        ]),
      );

  Widget orderBox(
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
                            .substring(0, 5)),
                    style: TextStyle(fontSize: 20),
                  ))),
        ]),
      );

  Future<void> _pullRefresh() async {
    this.myArticles.clear();
    this.pendingOrders.clear();
    this.completedOrders.clear();
    this.checkAnnouncements = false;
    this.checkPendingOrders = false;
    this.checkCompletedOrders = false;
    if (!user.isCustomer) {
      this.getSellersAnnouncements(user.userId);
    }
    this.getOrders(user.userId, user.isCustomer);
    await Future.delayed(Duration(seconds: 2));
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
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    width: size.width * 0.5,
                                    child: Text(
                                      user.fullname,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
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
                  SizedBox(height: size.height * 0.04),
                  if (user.isCustomer)
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'My orders',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: size.height * 0.02),
                            ],
                          ),
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
                                horizontal: size.height * 0.03),
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
                                    height: size.height * 0.30,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.05),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: this.myArticles.length,
                                      itemBuilder: (context, index) =>
                                          articleBox(
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
                                horizontal: size.height * 0.03),
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
                      this.pendingOrders.isEmpty && checkPendingOrders
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
                                    itemCount: this.pendingOrders.length,
                                    itemBuilder: (context, index) => orderBox(
                                        order: this.pendingOrders[index],
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
                                horizontal: size.height * 0.03),
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
                      this.completedOrders.isEmpty && checkCompletedOrders
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
                                    itemCount: this.completedOrders.length,
                                    itemBuilder: (context, index) => orderBox(
                                        order: this.completedOrders[index],
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
