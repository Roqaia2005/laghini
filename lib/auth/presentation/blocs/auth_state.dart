part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }

extension AuthStateX on AuthState {
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
final User? user;

  AuthState({required this.status, this.errorMessage, this.user});

  AuthState copyWith({AuthStatus? status, String? errorMessage, User? user}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}
