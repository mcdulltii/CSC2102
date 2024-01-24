part of 'chat_cubit.dart';

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

final class QueryErrorState extends ChatState {
  final String errorMessage;

  const QueryErrorState({required this.errorMessage});
}
