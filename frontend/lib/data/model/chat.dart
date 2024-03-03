class Chat {
  final String id;
  final String userId;
  final String title;
  final DateTime timestamp;

  Chat({
    required this.id,
    this.userId = "",
    required this.title,
    required this.timestamp,
  });
}
