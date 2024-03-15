import 'package:bloc/bloc.dart';

import 'package:frontend/data/repository/chat/chat_repository.dart';
import 'package:frontend/logic/chat/chat_event.dart';
import 'package:frontend/logic/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<ChatRetrieved>((event, emit) async {
      try {
        emit(ChatLoading());
        final chats = await _chatRepository.retrieveChats(event.userId);
        emit(ChatLoaded(event.id, chats));
      } catch (e) {
        emit(ChatError('Failed to load chats: $e'));
      }
    });

    on<ChatCreated>((event, emit) async {
      try {
        emit(ChatLoading());
        await _chatRepository.createChat(event.chat);
        emit(ChatSuccess('Chat added successfully'));
      } catch (e) {
        emit(ChatError('Failed to create chat: $e'));
      }
    });

    on<ChatUpdated>((event, emit) async {
      try {
        emit(ChatLoading());
        await _chatRepository.updateChat(event.chat);
        emit(ChatSuccess('Chat updated successfully'));
      } catch (e) {
        emit(ChatError('Failed to update chat: $e'));
      }
    });

    on<ChatDeleted>((event, emit) async {
      try {
        emit(ChatLoading());
        await _chatRepository.deleteChat(event.chatId);
        emit(ChatSuccess('Chat deleted successfully'));
      } catch (e) {
        emit(ChatError('Failed to delete chat: $e'));
      }
    });
  }
}
