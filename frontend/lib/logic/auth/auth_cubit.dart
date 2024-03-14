import 'package:bloc/bloc.dart';
import 'package:frontend/data/repository/auth/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  AuthCubit(this.repo) : super(AuthInitial());

  Future<void> signup(String email, String password) async {
    try {
      await repo.signUp(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      await repo.signIn(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
