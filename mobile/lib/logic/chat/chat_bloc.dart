import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/data/repos/query_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatQueryRepository repo;

  ChatBloc(this.repo) : super(ChatInitial()) {
    on<QuerySent>((event, emit) async {
      emit(QueryLoading());
      final response = await prompt(event.queryText);

      await Future.delayed(const Duration(milliseconds: 1500));

      emit(QueryLoaded(response: response));
    });
  }

  // Sample usage
  Future<String> prompt(String prompt) async {
    ChatQueryRepository prompter = ChatQueryRepository();

    String botResponse = await prompter.queryPrompt(prompt);

    print(botResponse);
    return botResponse;
  }
}
