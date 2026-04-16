import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/core/services/remote_database_service.dart';

abstract class AuthRemoteFirestore {
  Future<User> getUser(String userId);
  Future<void> save(Future<User> user);
}

class AuthRemoteFirestoreImpl implements AuthRemoteFirestore {
  final RemoteDatabaseService _remoteDatabaseService;

  AuthRemoteFirestoreImpl(this._remoteDatabaseService);
  @override
  Future<User> getUser(String userId) {
    return _remoteDatabaseService.get("users/$userId", User.fromMap);
  }

  @override
  Future<void> save(Future<User> user) async {
    final userData = await user;
    return _remoteDatabaseService.set(
      "users/${userData.id}",
      userData,
      (u) => u.toMap(),
    );
  }
}
