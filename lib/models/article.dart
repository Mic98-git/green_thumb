import 'package:flutter/material.dart';

class Article {
  late String articleId;
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
  late Image picture;
  late String quantityStock;

  Article(
      String articleId,
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
      Image articlePicture,
      String quantityStock) {
    this.articleId = articleId;
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
    this.quantityStock = quantityStock;
  }
}
