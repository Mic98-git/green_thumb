import 'dart:core';

import 'package:flutter/material.dart';
import 'package:green_thumb/core/api_client.dart';
import '../../config/global_variables.dart';
import '../../models/article.dart';
import '../../models/articleList.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navigation_bar.dart';
import '../article_page.dart';

class HomePageScreen extends StatefulWidget {
  static String id = "home_plants_page_screen";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Article> announcements = [];
  List<Article> plantAnnouncements = [];
  List<Article> toolAnnouncements = [];
  List<Article> searchArticles = [];
  String searchString = "";
  int _activeWidget = 0;
  bool checkPlants = false;
  bool checkTools = false;
  bool checkSearch = false;

  @override
  void initState() {
    super.initState();
    this.getAnnouncements().then((_) {
      setState(() {});
    });
  }

  Future<void> getAnnouncements() async {
    dynamic res = await _apiClient.getProducts();
    articleList articles = new articleList(res);
    for (var article in articles.list) {
      if (user.userId != article.sellerId) {
        if (article.category == "plant") {
          this.plantAnnouncements.add(article);
        } else {
          this.toolAnnouncements.add(article);
        }
      }
    }
    this.announcements.addAll(this.plantAnnouncements);
    this.announcements.addAll(this.toolAnnouncements);

    setState(() {
      this.checkPlants = true;
      this.checkTools = true;
    });
  }

  void showArticleDetails(Article a) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleScreen(article: a)))
        .then((_) {
      setState(() {});
    });
  }

  Future<void> addItemToCart(String userId, Article a) async {
    Article article = a;
    Map<String, dynamic> cartData = {
      "qty": 1,
      "price": article.price,
      "sellerId": article.sellerId
    };

    dynamic res = await _apiClient.addProductInCart(
        cartData, user.userId, article.articleId);

    if (res['error'] == null) {
      shoppingCartItems.addEntries((<String, Article>{a.articleId: a}).entries);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<void> removeItemFromCart(String userId, Article a) async {
    Article article = a;
    dynamic res =
        await _apiClient.deleteProductFromCart(user.userId, article.articleId);
    if (res['error'] == null) {
      shoppingCartItems.remove(a.articleId);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['error']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Widget articleBox({required Article item, required Size size}) => Container(
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.015),
                        child: Container(
                          height: size.height * 0.25,
                          width: size.width * 0.33,
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
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showArticleDetails(item);
                                  },
                                  child: Container(
                                    width: size.width * 0.4,
                                    child: Text(item.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ],
                          )),
                          SizedBox(height: size.height * 0.005),
                          Container(
                              child: Row(
                            children: [
                              Icon(
                                Icons.store,
                                color: Colors.grey,
                                size: 18,
                              ),
                              Container(
                                  width: size.width * 0.3,
                                  child: Text(
                                    ' ' + item.sellerName,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )),
                            ],
                          )),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Container(
                                  width: size.width * 0.35,
                                  child: Text(item.description,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[700])))
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 115,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    this.showArticleDetails(item);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'View more ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: size.width * 0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.euro, size: 18),
                                    Text(
                                      double.parse(item.price)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                            SizedBox(height: size.height * 0.01),
                            Row(children: [
                              IconButton(
                                onPressed: () {
                                  shoppingCartItems.containsKey(item.articleId)
                                      ? this
                                          .removeItemFromCart(user.userId, item)
                                      : this.addItemToCart(user.userId, item);
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Stack(
                                  children: <Widget>[
                                    Icon(Icons.shopping_cart_rounded),
                                    Positioned(
                                      left: 12,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 5,
                                            minHeight: 5,
                                          ),
                                          child: shoppingCartItems
                                                  .containsKey(item.articleId)
                                              ? Icon(
                                                  Icons.remove,
                                                  size: 12,
                                                  color: Colors.white,
                                                )
                                              : Icon(Icons.add,
                                                  size: 12,
                                                  color: Colors.white)),
                                    )
                                  ],
                                ),
                              )
                            ]),
                            SizedBox(height: size.height * 0.03),
                          ])
                    ],
                  ),
                ],
              )),
        ]),
      );

  Widget _homeBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    switch (_activeWidget) {
      case 2:
        return (this.searchArticles.isEmpty && checkSearch
            ? Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height.toDouble() / 4),
                    child: Text(
                      "No announcement found",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )),
              ])
            : Column(children: [
                SizedBox(height: size.height * 0.04),
                Container(
                    child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  itemCount: this.searchArticles.length,
                  itemBuilder: (context, index) =>
                      articleBox(item: this.searchArticles[index], size: size),
                  separatorBuilder: (context, _) =>
                      SizedBox(height: size.height * 0.02),
                )),
                SizedBox(height: size.height * 0.04),
              ]));
      case 1:
        return (this.toolAnnouncements.isEmpty && checkTools
            ? Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height.toDouble() / 4),
                    child: Text(
                      "No announcement posted",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )),
              ])
            : Column(children: [
                SizedBox(height: size.height * 0.04),
                Container(
                    child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  itemCount: this.toolAnnouncements.length,
                  itemBuilder: (context, index) => articleBox(
                      item: this.toolAnnouncements[index], size: size),
                  separatorBuilder: (context, _) =>
                      SizedBox(height: size.height * 0.02),
                )),
                SizedBox(height: size.height * 0.04),
              ]));
      default:
        return (this.plantAnnouncements.isEmpty && checkPlants
            ? Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height.toDouble() / 4),
                    child: Text(
                      "No announcement posted",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    )),
              ])
            : Column(children: [
                SizedBox(height: size.height * 0.04),
                Container(
                    child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  itemCount: this.plantAnnouncements.length,
                  itemBuilder: (context, index) => articleBox(
                      item: this.plantAnnouncements[index], size: size),
                  separatorBuilder: (context, _) =>
                      SizedBox(height: size.height * 0.02),
                )),
                SizedBox(height: size.height * 0.04),
              ]));
    }
  }

  Future<void> _pullRefresh() async {
    this.checkPlants = false;
    this.checkTools = false;
    this.plantAnnouncements.clear();
    this.toolAnnouncements.clear();
    this.announcements.clear();
    this.getAnnouncements().then((_) {
      setState(() {});
    });
    await Future.delayed(Duration(seconds: 2));
  }

  void searchArticle(
    String query,
  ) {
    final search = this.announcements.where((article) {
      final articleName = article.name.toLowerCase();
      final input = query.toLowerCase();

      return articleName.contains(input);
    }).toList();

    setState(() {
      this.searchArticles = search;
      this.checkSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.03),
                            child: FocusScope(
                                child: Focus(
                                    onFocusChange: (focus) => {
                                          if (focus)
                                            {
                                              setState(() {
                                                _activeWidget = 2;
                                              })
                                            }
                                          else
                                            {
                                              setState(() {
                                                _activeWidget = 0;
                                                this.searchString = "";
                                              }),
                                            }
                                        },
                                    child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            this.searchString =
                                                value.toLowerCase();
                                          });
                                          searchArticle(searchString);
                                          if (this.searchString == "") {
                                            this.searchArticles.clear();
                                            this.checkSearch = false;
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              this._activeWidget = 0;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Search something...',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          prefixIcon: Icon(
                                            Icons.search,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ))))),
                        if (this._activeWidget < 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _activeWidget = 0;
                                    });
                                  },
                                  child: Text(
                                    'Plants',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: _activeWidget == 0
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  style: _activeWidget == 0
                                      ? (ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // <-- Radius
                                          ),
                                          primary: primaryColor))
                                      : (ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ))),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _activeWidget = 1;
                                    });
                                  },
                                  child: Text(
                                    'Tools',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: _activeWidget == 1
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  style: _activeWidget == 1
                                      ? (ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // <-- Radius
                                          ),
                                          primary: primaryColor))
                                      : (ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)))))
                            ],
                          ),
                        _homeBody(context)
                      ],
                    )),
              ),
            )));
  }
}
