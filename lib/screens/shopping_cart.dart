import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/screens/puchase_procedure/shipping_info.dart';
import 'package:green_thumb/widgets/app_bar.dart';
import 'package:green_thumb/widgets/navigation_bar.dart';

import '../models/article.dart';

class ShoppingCartScreen extends StatefulWidget {
  static String id = "shopping_cart_screen";
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  var shoppingItems = <Article>[];
  double itemsPrice = 0.00;
  double shipping = 5;
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getCart(String cartId) async {
    dynamic res = await _apiClient.getCart(cartId);
    List<String> products = [];
    if (res['error'] == null && res['cart'].length > 0) {
      shoppingCartRequest = res['cart'][0]['cartItems'];
      for (var p in res['cart'][0]['cartItems']) {
        products.add(p['productId']);
      }
      dynamic res1 = await _apiClient.getProductsByList(products);
      if (res1['error'] == null) {
        for (var a in res1['products']) {
          final base64String = a['picture'];
          Image articleImage = Image.memory(base64Decode(base64String));
          shoppingCartItems.addEntries((<String, Article>{
            a['_id']: new Article(
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
                a['quantityStock'].toString())
          }).entries);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res1['error']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    } else if (res['cart'].length == 0) {
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  @override
  void initState() {
    getCart(user.userId);
    super.initState();
    for (var item in shoppingCartItems.values) {
      shoppingItems.add(item);
    }
    for (var item in shoppingItems) {
      itemsPrice += double.parse(item.price);
    }
  }

  /*Future<dynamic> removeItemFromCartDB(String cartId, String productId) async {
    return _apiClient.deleteProductFromCart(cartId, productId);
  }*/

  void removeItemFromCart(Article item, int index) async {
    dynamic res =
        await _apiClient.deleteProductFromCart(user.userId, item.articleId);
    if (res['error'] == null) {
      shoppingCartItems.remove(item.articleId);
      shoppingItems.removeAt(index);
      setState(() {
        this.itemsPrice -= double.parse(item.price);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  showRemoveAlertDialog(BuildContext context, Article item, int index) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        removeItemFromCart(item, index);
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    Widget undoButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Attention"),
      content: Text(
          "Are you sure you want to remove the item from your shopping cart?"),
      actions: [
        okButton,
        undoButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget items(
          {required Article item, required Size size, required int index}) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.20,
              width: size.width * 0.35,
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
                        width: size.width * 0.3,
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showRemoveAlertDialog(context, item, index);
                          },
                          icon: Icon(CupertinoIcons.delete_simple,
                              size: 25, color: Colors.red)),
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
                        double.parse(item.price).toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    "VAT 22% included",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ]),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 1;
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.09),
                child: appBarWidget(size, false)),
            backgroundColor:
                shoppingCartItems.length > 0 ? backgroundColor : Colors.white,
            bottomNavigationBar:
                BottomNavigationBarScreen(currentIndex: _currentIndex),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Shopping cart",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    shoppingCartItems.length > 0
                        ? Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.04),
                                  child: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * 0.03),
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * 0.05),
                                                itemCount:
                                                    shoppingCartItems.length,
                                                itemBuilder: (context, index) =>
                                                    items(
                                                        item: shoppingItems[
                                                            index],
                                                        size: size,
                                                        index: index),
                                                separatorBuilder:
                                                    (context, _) => SizedBox(
                                                        height:
                                                            size.height * 0.03),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.8,
                                                height: size.height * 0.1,
                                                child: Divider(
                                                    color: primaryColor),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.width * 0.05),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Articles: ",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          Icon(Icons.euro,
                                                              size: 20),
                                                          Text(
                                                            itemsPrice
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.01,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Shipping: ",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          Icon(Icons.euro,
                                                              size: 20),
                                                          Text(
                                                            shipping
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.03,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Total: ",
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Icon(Icons.euro,
                                                              size: 25),
                                                          Text(
                                                            (itemsPrice +
                                                                    shipping)
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          )))),
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
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShippingInfoScreen(
                                                    itemsPrice: itemsPrice +
                                                        this.shipping,
                                                    articlesList:
                                                        this.shoppingItems,
                                                  )));
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Purchase ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                          Icon(
                                            Icons.shopping_cart_checkout,
                                            size: 30,
                                          )
                                        ])),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.2,
                              ),
                              Icon(Icons.shopping_cart_outlined,
                                  color: Colors.grey, size: 100),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                "Your shopping cart is empty",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                ))));
  }
}
