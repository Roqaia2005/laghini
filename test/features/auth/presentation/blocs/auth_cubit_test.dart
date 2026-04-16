import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';
import 'package:la8ini/auth/presentation/blocs/auth_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

class FakeAuthRepository implements AuthRepo {
  final List<User> _users = [
    User(id: "0", fullname: "Roqaia Hassan", email: "roqaia@example.com"),
    User(id: "2", fullname: "John Doe", email: "john@example.com"),
    User(id: "1", fullname: "testht", email: "test@example.com")
  ];
  @override
  Future<User> login(String email, String password) {
    final user = _users.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception("User not found"),
    );
    if (password != "123456") {
      throw Exception("User password is incorrect");
    }
    return Future.delayed(const Duration(seconds: 1), () => user);
  }

  @override
  Future<User> signup(String fullname,String email, String password) {
    final existingUser = _users.any((user) => user.email == email);
    if (existingUser) {
      throw Exception("This email is already in use");
    }
    final newUser = User(id: "4", fullname: "New User", email: email);
    _users.add(newUser);
    return Future.delayed(const Duration(seconds: 1), () => newUser);
  }

  @override
  Future<void> logout() {
    return Future.delayed(const Duration(seconds: 1), () {});
  }
}

void main() {
  late AuthRepo _authRepository;
  late AuthCubit _authCubit;

  setUp(() {
    _authRepository = FakeAuthRepository();
    _authCubit = AuthCubit(_authRepository);
  });
  tearDown(() {
    _authCubit.close();
  });

group("login", () {
    blocTest(
      "emit [AuthStatus.loading,AuthStatus.loaded] when login is successful",
      
      act: (cubit) => cubit.login("test@example.com", "123456"),
      build: () => _authCubit,
      expect: () => [
        AuthState(status: AuthStatus.loading),
        AuthState(
          status: AuthStatus.loaded,
          user: User(id: "1", email: "test@example.com", fullname: "test"),
        ),
      ],
    );

    blocTest(
      'emits [AuthStatus.loading, AuthStatus.error] when login is failed',
      build: () => _authCubit,
      
      act: (cubit) => cubit.login("test@example.com", "123456"),
      expect: () => [
        AuthState(status: AuthStatus.loading),
        AuthState(
          status: AuthStatus.error,
          message: "Exception: User password is incorrect",
        ),
      ],
    );
  });

  group("signup", () {
    blocTest(
      "emit [loading, success] when signup is successful",
    
      act: (bloc) => bloc.signup("Test User", "test@example.com", "123456"),

      build: () => _authCubit,
      expect: () => [
        AuthState(status: AuthStatus.loading),
        AuthState(
          status: AuthStatus.loaded,
          user: User(id: "1", email: "test@example.com", fullname: "Test User"),
        ),
      ],
    );
    blocTest(
      'emits [AuthStatus.loading, AuthStatus.error] when signup is failed',
      build: () => _authCubit,
      act: (cubit) => cubit.signup("Test User", "test@example.com", "123456"),
      
      expect: () => [
        AuthState(status: AuthStatus.loading),
        AuthState(
          status: AuthStatus.error,
          message: "Exception: This email is already in use",
        ),
      ],
    );

//test signup
  });
}
