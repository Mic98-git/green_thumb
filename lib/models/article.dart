import 'package:flutter/material.dart';

class Article {
  late String sellerId;
  late String sellerName;
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
      String sellerId,
      String sellerName,
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
    this.sellerId = sellerId;
    this.sellerName = sellerName;
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
}
