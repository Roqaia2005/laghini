import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/auth/data/repo/auth_repo_impl.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepoImpl authRepo;
  AuthCubit(this.authRepo) : super(AuthState(status: AuthStatus.initial));

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await authRepo.login(email, password);
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
