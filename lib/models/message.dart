class Message {
  const Message(
      {required this.chatId,
      required this.userId,
      required this.content,
      required this.createdAt,
      required this.idConversation});

  /// ID of the message
  final String chatId;

  /// ID of the user who posted the message
  final String userId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final String createdAt;

  final String idConversation;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        chatId: json['mess']['_id'],
        userId: json['mess']['userId'],
        createdAt: json['mess']['created_at'],
        content: json['mess']['content'],
        idConversation: json['mess']['idConversation']);
  }
}
