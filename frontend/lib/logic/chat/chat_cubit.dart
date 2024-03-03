import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/message.dart';
import 'package:frontend/data/repository/chat/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo repo;

  List<Message> messages = [];

  ChatCubit(this.repo) : super(ChatInitial());

  Future<void> sendQuery(String text) async {
    final userMessage =
        Message(isBot: true, timestamp: DateTime.now(), payload: text);

    messages.add(userMessage);
    emit(ChatQueryLoading());
    try {
      final result = await repo.queryPrompt(text);

      final botMessage = Message(
        isBot: false,
        timestamp: DateTime.now(),
        payload: result,
      );

      messages.add(botMessage);

      emit(ChatQueryLoaded());
    } catch (e) {
      emit(QueryResultError(message: e.toString()));
    }
  }
}
