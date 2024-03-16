class Message {
  final String chatId;
  final bool isBot;
  final String payload;
  final DateTime timestamp;

  const Message({
    this.chatId = "",
    required this.isBot,
    required this.payload,
    required this.timestamp,
  });
}
