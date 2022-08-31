import 'package:green_thumb/models/article.dart';

class Order {
  final String userId;
  final String fullname;
  final String address;
  final String city;
  final String payment;
  final List<Article> cart;
  final int total;
  final double latitude;
  final double longitude;
  final String createdAt;

  const Order(
      {required this.userId,
      required this.fullname,
      required this.address,
      required this.city,
      required this.payment,
      required this.cart,
      required this.total,
      required this.latitude,
      required this.longitude,
      required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        userId: json['order']['userId'],
        fullname: json['order']['fullname'],
        address: json['order']['address'],
        city: json['order']['city'],
        payment: json['order']['payment'],
        cart: json['order']['cart'][0]['_id'],
        total: json['order']['total'],
        latitude: json['order']['latitude'],
        longitude: json['order']['longitude'],
        createdAt: json['order']['created_at']);
  }
}
