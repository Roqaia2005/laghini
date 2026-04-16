import 'package:la8ini/core/services/cache_service.dart';
import 'package:la8ini/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(Future<User> user);
  Future<User?> getCachedUser();
}

const String USER_CACHE_KEY = 'USER-CACHE_KEY';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheService _cacheService;
  AuthLocalDataSourceImpl(this._cacheService);

  @override
  Future<void> cacheUser(Future<User> user) async {
    final userData = await user;
    await _cacheService.setString(USER_CACHE_KEY, userData.toJson());
  }

  @override
  Future<User?> getCachedUser() async {
    final userJson = await _cacheService.getString(USER_CACHE_KEY);
    if (userJson != null) {
      return User.fromJson(userJson);
    } else {
      return null;
    }
  }
}
