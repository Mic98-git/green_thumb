import 'dart:core';

import 'package:flutter/material.dart';
import 'package:green_thumb/core/api_client.dart';
import 'package:green_thumb/screens/home_page/home_tools_page.dart';
import '../../config/global_variables.dart';
import '../../models/article.dart';
import '../../models/articleList.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navigation_bar.dart';
import '../article_page.dart';

class HomePlantsPageScreen extends StatefulWidget {
  static String id = "home_plants_page_screen";
  const HomePlantsPageScreen({Key? key}) : super(key: key);

  @override
  State<HomePlantsPageScreen> createState() => _HomePlantsPageScreenState();
}

class _HomePlantsPageScreenState extends State<HomePlantsPageScreen> {
  List<Article> plantAnnouncements = [];
  List<Article> toolAnnouncements = [];
  bool checkPlants = false;
  bool checkTools = false;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    this.getPlantAnnouncements().then((_) {
      setState(() {});
    });
  }

  Future<void> getPlantAnnouncements() async {
    dynamic res = await _apiClient.getProducts();
    articleList articles = new articleList(res);
    for (var article in articles.list) {
      if (article.category == "plant") {
        this.plantAnnouncements.add(article);
      } else {
        this.toolAnnouncements.add(article);
      }
    }
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

  Widget articleBox({required Article item, required Size size}) => Container(
        child: Column(children: [
          Container(
              width: double.infinity,
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
          SizedBox(height: size.height * 0.02),
          Container(
              width: double.infinity,
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

  Future<void> _pullRefresh() async {}

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
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Plants',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                                primary: primaryColor)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeToolsPageScreen(
                                        tools: this.toolAnnouncements,
                                        checkTools: this.checkTools)));
                          },
                          child: Text(
                            'Tools',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    this.plantAnnouncements.isEmpty && checkPlants
                        ? Column(children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height.toDouble() / 3),
                                child: Text(
                                  "No announcement posted",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                )),
                          ])
                        : Column(children: [
                            SizedBox(height: size.height * 0.05),
                            Container(
                                child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05),
                              itemCount: this.plantAnnouncements.length,
                              itemBuilder: (context, index) => articleBox(
                                  item: this.plantAnnouncements[index],
                                  size: size),
                              separatorBuilder: (context, _) =>
                                  SizedBox(height: size.height * 0.05),
                            )),
                            SizedBox(height: size.height * 0.05),
                          ])
                  ],
                )),
          ),
        ));
  }
}
