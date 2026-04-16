import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  AuthCubit(this._authRepo) : super(AuthState(status: AuthStatus.initial));

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepo.login(email, password);
      emit(state.copyWith(status: AuthStatus.loaded, user: () => user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> signup(String fullname, String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepo.signup(fullname, email, password);
      emit(state.copyWith(status: AuthStatus.loaded, user: () => user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }
}
