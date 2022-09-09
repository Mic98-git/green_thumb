import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/models/article.dart';
import 'package:green_thumb/screens/chat/chat.dart';
import 'package:green_thumb/screens/my_account.dart';
import 'package:green_thumb/screens/shopping_cart.dart';
import '../widgets/app_bar.dart';

class ArticleScreen extends StatefulWidget {
  static String id = "Article_screen";
  final Article article;
  const ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ApiClient _apiClient = ApiClient();

  Future<void> deleteAnnouncement() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));

    dynamic res = await _apiClient.deleteProduct(widget.article.articleId);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (res['error'] == null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> addItemToCart(String userId) async {
    Article article = widget.article;
    Map<String, dynamic> cartData = {
      "qty": 1,
      "price": article.price,
      "sellerId": article.sellerId
    };

    dynamic res = await _apiClient.addProductInCart(
        cartData, user.userId, article.articleId);

    if (res['error'] == null) {
      shoppingCartItems.addEntries((<String, Article>{
        widget.article.articleId: widget.article
      }).entries);
      showAddAlertDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> removeItemFromCart(String userId) async {
    Article article = widget.article;
    dynamic res =
        await _apiClient.deleteProductFromCart(user.userId, article.articleId);
    if (res['error'] == null) {
      shoppingCartItems.remove(widget.article.articleId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  showDeleteProductAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        this.deleteAnnouncement().then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyAccountScreen())));
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
      content: Text("Are you sure you want to remove this announcement?"),
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

  showRemoveAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        removeItemFromCart(user.userId);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
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

  showAddAlertDialog(BuildContext context) {
    // set up the button
    Widget purchaseButton = TextButton(
      child: Text("Purchase"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ShoppingCartScreen()));
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continue shopping"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Congratulations"),
      content: Text("The item has been added to your shopping cart"),
      actions: [
        continueButton,
        purchaseButton,
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

  void contactSeller() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                widget.article.sellerName, widget.article.sellerId)));
  }

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
              user.userId == widget.article.sellerId
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(CupertinoIcons.delete_simple,
                              size: 25, color: Colors.red),
                          onPressed: () {
                            showDeleteProductAlertDialog(context);
                          },
                        ),
                      ],
                    )
                  : SizedBox(
                      height: size.height * 0.03,
                    ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.article.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.article.latinName,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ),
              widget.article.sellerId != user.userId
                  ? SizedBox(
                      height: 0,
                    )
                  : SizedBox(
                      height: size.height * 0.02,
                    ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.store,
                      color: Colors.grey,
                    ),
                    Text(
                      ' ' + widget.article.sellerName,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    widget.article.sellerId != user.userId
                        ? TextButton(
                            onPressed: contactSeller,
                            child: Text(
                              ' Contact us!',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                          )
                        : Text("")
                  ]),
              widget.article.sellerId != user.userId
                  ? SizedBox(
                      height: size.height * 0.01,
                    )
                  : SizedBox(
                      height: size.height * 0.02,
                    ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                  child: AspectRatio(
                    aspectRatio: 5 / 4,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FittedBox(
                          child: widget.article.picture,
                          fit: BoxFit.contain,
                        )),
                  )),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.water_drop_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Text(
                    ' ' + widget.article.waterFrequency,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        child: Image.asset('assets/icons/oxygen.png'),
                      ),
                      Text(
                        '  ' + widget.article.oxygen + ' grams/day',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.sunny,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  Text(
                    ' ' + widget.article.sunlight,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          'Price: ' +
                              double.parse(widget.article.price)
                                  .toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      Icon(Icons.euro, size: 25),
                    ],
                  ),
                  widget.article.sellerId != user.userId
                      ? Row(
                          children: [
                            Container(
                              height: 40,
                              width: 100,
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
                                  shoppingCartItems
                                          .containsKey(widget.article.articleId)
                                      ? showRemoveAlertDialog(context)
                                      : this.addItemToCart(user.userId);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_cart,
                                      size: 35,
                                    ),
                                    shoppingCartItems.containsKey(
                                            widget.article.articleId)
                                        ? Icon(
                                            Icons.remove,
                                            size: 15,
                                          )
                                        : Icon(
                                            Icons.add,
                                            size: 15,
                                          )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        )
                      : Row()
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(widget.article.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic))
                        ],
                      ))),
              SizedBox(
                height: size.height * 0.05,
              ),
            ])));
  }
}
