class Chat {
  final String id;
  final String userId;
  final String title;
  final DateTime timestamp;

  Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.timestamp,
  });

  Chat copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? timestamp,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Convert Chat object to a Map
  Map<String, dynamic> toJson() {
    return {
      'chatId': id,
      'userId': userId,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a Chat object from JSON data
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
