import 'package:green_thumb/models/article.dart';

class Order {
  final String orderId;
  final String userId;
  final String fullname;
  final String address;
  final String city;
  final String payment;
  final List<Article> cart;
  final double total;
  final double latitude;
  final double longitude;
  final String createdAt;
  final bool delivered;
  final bool deliveryInProgress;
  final int ratingValue;

  const Order(
      {required this.orderId,
      required this.userId,
      required this.fullname,
      required this.address,
      required this.city,
      required this.payment,
      required this.cart,
      required this.total,
      required this.latitude,
      required this.longitude,
      required this.createdAt,
      required this.delivered,
      required this.deliveryInProgress,
      required this.ratingValue});
}
