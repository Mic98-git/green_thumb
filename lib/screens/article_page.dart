import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/models/article.dart';
import 'package:green_thumb/screens/chat/chat.dart';
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
  void addItemToCart() {
    shoppingCartItems.addEntries(
        (<String, Article>{widget.article.articleId: widget.article}).entries);
    showAddAlertDialog(context);
  }

  void removeItemFromCart() {
    shoppingCartItems.remove(widget.article.articleId);
  }

  showRemoveAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        removeItemFromCart();
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
              SizedBox(
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
                height: size.height * 0.02,
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
                    Icon(Icons.store),
                    Text(
                      ' ' + widget.article.sellerName,
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    widget.article.sellerId != user.userId
                        ? TextButton(
                            onPressed: contactSeller,
                            child: Text(
                              ' Contact us!',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
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
                          fit: BoxFit.cover,
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
                      fontSize: 20,
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
                          fontSize: 20,
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
                      fontSize: 20,
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
                      Text('Price: ' + widget.article.price,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
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
                                      : this.addItemToCart();
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
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic))
                        ],
                      ))),
              SizedBox(
                height: size.height * 0.05,
              ),
            ])));
  }
}
