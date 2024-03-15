import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:frontend/data/model/message.dart';
import 'package:frontend/data/repository/chat/message_repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository repo;

  List<Message> messages = [];

  bool isError = false;

  MessageCubit(this.repo) : super(MessageInitial());

  Future<void> sendQuery(String text) async {
    final userMessage =
        Message(isBot: true, timestamp: DateTime.now(), payload: text);

    messages.add(userMessage);
    emit(MessageQueryLoading());
    try {
      final result = await repo.queryPrompt(text);

      _checkError(result);

      final botMessage = Message(
        isBot: false,
        timestamp: DateTime.now(),
        payload: result,
      );

      messages.add(botMessage);

      emit(MessageQueryLoaded());
    } catch (e) {
      emit(MessageQueryResultError(message: e.toString()));
    }
  }

  void _checkError(String result) {
    if (result == "The request timed out. Please try again." ||
        result ==
            "I apologize, there was an error processing your query. Please try again.") {
      isError = true;
    } else {
      isError = false;
    }
  }
}
