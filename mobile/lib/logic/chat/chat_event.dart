part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class QuerySent extends ChatEvent {
  final String queryText;

  const QuerySent({required this.queryText});
}
