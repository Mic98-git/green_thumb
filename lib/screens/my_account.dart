import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/widgets/app_bar.dart';
import 'package:green_thumb/widgets/navigation_bar.dart';
import './announcement_creation/new_article.dart';
import 'article_page.dart';
import '../models/article.dart';
import '../core/api_client.dart';
import '../models/articleList.dart';

class MyAccountScreen extends StatefulWidget {
  static String id = "my_account_screen";
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Article> myArticles = [];
  bool check = false;
  Image profileImage = Image.asset('assets/images/image.png');

  @override
  void initState() {
    super.initState();
    this.getSellersAnnouncements(user.userId);
  }

  Future<void> getSellersAnnouncements(String userId) async {
    dynamic res = await _apiClient.getSellersProducts(userId);
    articleList articles = new articleList(res);
    setState(() {
      this.myArticles = articles.list;
      check = true;
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
                        "My Account",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.045),
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
                                      width: size.width * 0.03,
                                    ),
                                    Container(
                                      width: size.width * 0.4,
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
                                      width: size.width * 0.02,
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
                                        onPressed: () {},
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
                                        width: size.width * 0.02,
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
                                                      BorderRadius.circular(
                                                          20))),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: size.height * 0.02),
                              ],
                            ),
                          )
                        ],
                      )
                    else
                      Column(
                        children: <Widget>[
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
                          myArticles.isEmpty && check
                              ? Column(children: [
                                  SizedBox(height: size.height * 0.09),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                          'No announcement posted. Create your first one!',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ))),
                                ])
                              : Column(children: [
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
                                            articleBox(
                                                item: this.myArticles[index],
                                                size: size),
                                        separatorBuilder: (context, _) =>
                                            SizedBox(width: size.width * 0.05),
                                      ))
                                ]),
                          myArticles.isEmpty && check
                              ? SizedBox(height: size.height * 0.09)
                              : SizedBox(height: size.height * 0.01),
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
                          SizedBox(height: size.height * 0.02),
                          Container(
                              height: size.height * 0.3,
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05),
                                scrollDirection: Axis.horizontal,
                                itemCount: this.myArticles.length,
                                itemBuilder: (context, index) => articleBox(
                                    item: this.myArticles[index], size: size),
                                separatorBuilder: (context, _) =>
                                    SizedBox(width: size.width * 0.03),
                              ))
                        ],
                      ),
                    SizedBox(height: size.height * 0.03),
                  ],
                ))));
  }
}
