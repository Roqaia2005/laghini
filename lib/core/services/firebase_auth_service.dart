import 'package:la8ini/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class FirebaseAuthService {
  Future<User> login(String email, String password);
  Future<User> signup(String fullname, String email, String password);
  Future<void> logout();
}

class RemoteAuthServiceImpl implements FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  RemoteAuthServiceImpl(this._firebaseAuth);

  @override
  Future<User> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Failed to login');
    }
    final userAdapter = FirebaseAuthUserAdapter();
    return userAdapter.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<User> signup(String fullname, String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Failed to signup');
    }
    await firebaseUser.updateDisplayName(fullname);
    final userAdapter = FirebaseAuthUserAdapter();

    return userAdapter.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

class FirebaseAuthUserAdapter {
  User fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      fullname: firebaseUser.displayName ?? '',
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );
  }
}
