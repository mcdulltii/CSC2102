import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/data/repository/query_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatQueryRepository _repo;


  ChatCubit(this._repo) : super(ChatInitial());

  Future<void> getPrompt(String value) async {
    emit(QueryLoading());

    try {
      final response = await _repo.queryPrompt(value);

      emit(QueryLoaded(response: response));
    } catch (e) {
      emit(QueryErrorState(
        errorMessage: e.toString(),
      ));
    }
  }
}
