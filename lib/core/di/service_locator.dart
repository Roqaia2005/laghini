import 'package:get_it/get_it.dart';
import 'package:la8ini/core/services/auth_service.dart';
import 'package:la8ini/auth/data/repo/auth_repo_impl.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';
import 'package:la8ini/auth/presentation/blocs/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton(() => AuthRepoImpl());
  getIt.registerFactory(() => AuthCubit(getIt.call()));
  getIt.registerFactory(() => AuthService());
}
