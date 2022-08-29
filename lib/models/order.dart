class Order {
  final String userId;
  final int total;
  final String createdAt;
  final double latitude;
  final double longitude;
  final String productId;
  final int quantity;

  const Order(
      {required this.userId,
      required this.total,
      required this.createdAt,
      required this.latitude,
      required this.longitude,
      required this.productId,
      required this.quantity});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        userId: json['ord']['user'],
        total: json['ord']['total'],
        createdAt: json['ord']['created_at'],
        latitude: json['ord']['latitude'],
        longitude: json['ord']['longitude'],
        productId: json['ord']['orderItems'][0]['product'],
        quantity: json['ord']['orderItems'][0]['qty']);
  }
}
