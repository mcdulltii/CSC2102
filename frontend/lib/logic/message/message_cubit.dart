import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:frontend/data/model/message.dart';
import 'package:frontend/data/repository/chat/message_repository.dart';
import 'package:frontend/logic/helper/chat_helper.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository repo;

  List<Message> messages = [];

  bool isError = false;

  String currChatId = "";
  String botLastMessage = "";

  MessageCubit(this.repo) : super(MessageInitial());

  Future<void> sendQuery(String text) async {
    final userMessage =
        Message(isBot: false, timestamp: DateTime.now(), payload: text);

    final chatId = await getChatIdFromLocalStorage();
    repo.createMessage(chatId!, false, text, DateTime.now());
    messages.add(userMessage);
    emit(MessageQueryLoading());

    try {
      final result = await repo.queryPrompt(text);
      _checkError(result);

      final botMessage = Message(
        isBot: true,
        timestamp: DateTime.now(),
        payload: result,
      );

      botLastMessage = result;

      messages.add(botMessage);
      repo.createMessage(chatId, true, result, DateTime.now());

      emit(MessageQueryLoaded(text: result));
    } catch (e) {
      emit(MessageQueryResultError(message: e.toString()));
    }
  }

  Future<void> getMessagesByChatId(String chatId) async {
    emit(MessageQueryLoading());
    // clear previous chat messages
    messages = [];

    currChatId = chatId;

    try {
      final fetchedMessages = await repo.getAllChatsByChatId(chatId);
      messages = fetchedMessages;
      botLastMessage = messages.last.payload;
      emit(MessageQueryLoaded());
    } catch (e) {
      emit(MessageQueryResultError(message: e.toString()));
    }
  }

  Future<void> deleteMessagesByChatId(String chatId) async {
    // call repo to backend to delete messages
    await repo.deleteAllChatsByChatId(chatId);
    await getMessagesByChatId(currChatId);
  }

  Future<void> isChatSelected() async {
    final chatId = await getChatIdFromLocalStorage();

    if (chatId == null) {
      emit(MessagesEmpty());
    } else {
      emit(MessageQueryLoaded());
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

  void removeAllMessage() {
    messages = [];
  }
}
