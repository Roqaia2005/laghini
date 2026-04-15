import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<User> login(String email, String password) {
    // Simulate a login process
    return Future.delayed(const Duration(seconds: 2), () {
      return User(id: '1', email: email, name: 'Roqaia');
    });
  }

  @override
  Future<User> register(String email, String password) {
    // Simulate a registration process
    return Future.delayed(const Duration(seconds: 2), () {
      return User(id: '2', email: email, name: 'Roqaia');
    });
  }

  @override
  Future<void> logout() {
    // Simulate a logout process
    return Future.delayed(const Duration(seconds: 1), () {});
  }
}
