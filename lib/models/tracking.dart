class Tracking {
  final double latitude;
  final double longitude;

  const Tracking({
    required this.latitude,
    required this.longitude,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      latitude: json['order']['latitude'],
      longitude: json['order']['longitude'],
    );
  }
}
