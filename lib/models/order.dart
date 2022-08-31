class Order {
  final String userId;
  final String fullname;
  final String address;
  final String city;
  final String payment;
  final String sellerId;
  final String productId;
  final int quantity;
  final int price;
  final String cartId;
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
      required this.sellerId,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.cartId,
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
        sellerId: json['order']['cart'][0]['sellerId'],
        productId: json['order']['cart'][0]['productId'],
        quantity: json['order']['cart'][0]['qty'],
        price: json['order']['cart'][0]['price'],
        cartId: json['order']['cart'][0]['_id'],
        total: json['order']['total'],
        latitude: json['order']['latitude'],
        longitude: json['order']['longitude'],
        createdAt: json['order']['created_at']);
  }
}
