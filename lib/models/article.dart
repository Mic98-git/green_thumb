import 'package:flutter/material.dart';

class Article {
  late String seller;
  late String name;
  late String latinName;
  late String description;
  late String category;
  late String waterFrequency;
  late String oxygen;
  late String sunlight;
  late String price;
  late Image picture; //todo

  Article(
      String seller,
      String articleName,
      String articleLatinName,
      String articleDescription,
      String articleCategory,
      String articleWater,
      String articleOxygen,
      String articleSunlight,
      String articlePrice,
      Image articlePicture) {
    //todo
    this.seller = seller;
    this.name = articleName;
    this.latinName = articleLatinName;
    this.description = articleDescription;
    this.category = articleCategory;
    this.waterFrequency = articleWater;
    this.oxygen = articleOxygen;
    this.sunlight = articleSunlight;
    this.price = articlePrice;
    this.picture = articlePicture;
  }

  /*Article getArticleInfo() {
    return Article();
  }*/

}
