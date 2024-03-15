import 'package:frontend/data/model/chat.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final String id;
  final List<Chat> chats;

  ChatLoaded(this.id, this.chats);
}

final class ChatSuccess extends ChatState {
  final String message;

  ChatSuccess(this.message);
}

final class ChatError extends ChatState {
  final String errorMessage;

  ChatError(this.errorMessage);
}
