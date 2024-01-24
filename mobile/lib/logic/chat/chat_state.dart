part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class QueryLoading extends ChatState {}

final class QueryLoaded extends ChatState {
  final String response;

  const QueryLoaded({required this.response});
}
