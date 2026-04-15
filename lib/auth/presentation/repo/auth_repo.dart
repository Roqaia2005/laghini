import 'package:la8ini/auth/data/models/user_model.dart';

abstract class AuthRepo{
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
}