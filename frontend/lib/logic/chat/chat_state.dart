part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatQueryLoading extends ChatState {}

final class ChatQueryLoaded extends ChatState {}

final class QueryResultError extends ChatState {
  final String message;

  QueryResultError({required this.message});
}
