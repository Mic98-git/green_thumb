import 'dart:collection';

import 'article.dart';

class articleList {
  late List<Article> list;

  articleList(LinkedHashMap<String, dynamic> data) {
    this.list = <Article>[];
    for (var p in data['products']) {
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
          p['picture']));
    }
  }
}
