part of 'message_cubit.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageQueryLoading extends MessageState {}

final class MessageQueryLoaded extends MessageState {}

final class MessageQueryResultError extends MessageState {
  final String message;

  MessageQueryResultError({required this.message});
}