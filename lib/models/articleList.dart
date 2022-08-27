import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import 'article.dart';

class articleList {
  late List<Article> list;
  articleList(LinkedHashMap<String, dynamic> data) {
    this.list = <Article>[];
    for (var p in data['product']) {
      final base64String = p['picture'];
      Image articleImage = Image.memory(base64Decode(base64String));
      list.add(new Article(
          p['seller'],
          p['name'],
          p['latin'],
          p['description'],
          p['category'],
          p['water'],
          p['oxygen'].toString(),
          p['sunlight'],
          p['price'].toString(),
          articleImage)); //todo
    }
  }
}
