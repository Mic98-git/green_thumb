class Message {
  const Message(
      {required this.chatId,
      required this.userId,
      required this.content,
      required this.createdAt});

  /// ID of the message
  final String chatId;

  /// ID of the user who posted the message
  final String userId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final String createdAt;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        chatId: json['mess'][0]['_id'],
        userId: json['mess'][0]['userId'],
        createdAt: json['mess'][0]['created_at'],
        content: json['mess'][0]['content']);
  }
}
