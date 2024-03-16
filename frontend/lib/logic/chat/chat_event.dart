import 'package:frontend/data/model/chat.dart';

sealed class ChatEvent {}

final class ChatRetrieved extends ChatEvent {
  final String id;
  final String userId;

  ChatRetrieved(this.id, this.userId);
}

final class ChatCreated extends ChatEvent {
  final Chat chat;

  ChatCreated(this.chat);
}

final class ChatUpdated extends ChatEvent {
  final Chat chat;

  ChatUpdated(this.chat);
}

final class ChatDeleted extends ChatEvent {
  final String chatId;

  ChatDeleted(this.chatId);
}
