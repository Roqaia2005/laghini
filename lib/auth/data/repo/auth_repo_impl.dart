import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';
import 'package:la8ini/auth/data/data_source/auth_remote_firestore.dart';
import 'package:la8ini/auth/data/data_source/auth_local_data_source.dart';
import 'package:la8ini/auth/data/data_source/auth_remote_firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteFirebaseAuth _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteFirestore _authRemoteFirestore;

  AuthRepoImpl({
    required AuthRemoteFirebaseAuth authRemoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
    required AuthRemoteFirestore authRemoteFirestore,
  }) : _authRemoteDataSource = authRemoteDataSource,
       _authLocalDataSource = authLocalDataSource,
       _authRemoteFirestore = authRemoteFirestore;

  @override
  Future<User> login(String email, String password) async {
    final userCredential = await _authRemoteDataSource.login(email, password);
    final user = _authRemoteFirestore.getUser(userCredential.id);
    _authLocalDataSource.cacheUser(user);

    return user;
  }

  @override
  Future<User> signup(String fullname, String email, String password) {
    final user = _authRemoteDataSource.signup(fullname, email, password);

    _authLocalDataSource.cacheUser(user);
    _authRemoteFirestore.save(user);

    return user;
  }

  @override
  Future<void> logout() {
    return Future.delayed(const Duration(seconds: 1), () {});
  }
}
