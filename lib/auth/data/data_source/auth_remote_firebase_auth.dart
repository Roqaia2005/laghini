import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:la8ini/core/services/firebase_auth_service.dart';


abstract class AuthRemoteFirebaseAuth {
  Future<User> login(String email, String password);
  Future<User> signup(String fullname,String email, String password);
}

class AuthRemoteFirebaseAuthImpl implements AuthRemoteFirebaseAuth {
  final FirebaseAuthService _firebaseAuthService;
  AuthRemoteFirebaseAuthImpl(this._firebaseAuthService);
  @override
  Future<User> login(String email, String password) async {
    final user = _firebaseAuthService.login(email, password);

    return user;
  }

  @override
  Future<User> signup(String fullname, String email, String password) async {
    final user = _firebaseAuthService.signup(fullname, email, password);

    return user;
  }
}
