class Message {
  final bool isBot;
  final String payload;
  final DateTime timestamp;

  const Message({
    required this.isBot,
    required this.payload,
    required this.timestamp,
  });
}
