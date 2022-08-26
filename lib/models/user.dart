class User {
  const User({required this.fullname, required this.userId});

  /// Username of the profile
  final String fullname;

  final String userId;

  String get getName {
    return fullname;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(fullname: json['user']['fullname'], userId: json['user']['id']);
  }
}
