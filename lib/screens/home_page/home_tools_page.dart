import 'dart:core';

import 'package:flutter/material.dart';
import '../../config/global_variables.dart';
import '../../models/article.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navigation_bar.dart';
import '../article_page.dart';

class HomeToolsPageScreen extends StatefulWidget {
  static String id = "home_tools_page_screen";
  final List<Article> tools;
  final bool checkTools;
  const HomeToolsPageScreen(
      {Key? key, required this.tools, required this.checkTools})
      : super(key: key);

  @override
  State<HomeToolsPageScreen> createState() => _HomeToolsPageScreenState();
}

class _HomeToolsPageScreenState extends State<HomeToolsPageScreen> {
  @override
  void initState() {
    super.initState();
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
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Plants',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Tools',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                                primary: primaryColor))
                      ],
                    ),
                    widget.tools.isEmpty && widget.checkTools
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
                              itemCount: widget.tools.length,
                              itemBuilder: (context, index) => articleBox(
                                  item: widget.tools[index], size: size),
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
