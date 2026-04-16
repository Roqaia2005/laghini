import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la8ini/core/services/cache_service.dart';
import 'package:la8ini/auth/data/repo/auth_repo_impl.dart';
import 'package:la8ini/auth/presentation/repo/auth_repo.dart';
import 'package:la8ini/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8ini/core/services/firebase_auth_service.dart';
import 'package:la8ini/core/services/remote_database_service.dart';
import 'package:la8ini/auth/data/data_source/auth_remote_firestore.dart';
import 'package:la8ini/auth/data/data_source/auth_local_data_source.dart';
import 'package:la8ini/auth/data/data_source/auth_remote_firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';



final sl = GetIt.instance;

void initServiceLocator() {
  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  // sl.registerFactory(() => ChatCubit(sl()));
  // sl.registerFactory<ChatRoomCubit>(
  //   () => ChatRoomCubit(chatRepository: sl()),
  // );
  // sl.registerFactory(() => SearchUsersBloc(homeRepository: sl()));

  // sl.registerFactory(() => DrawingBoardBloc(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(
        authLocalDataSource: sl(),
        authRemoteDataSource: sl(),
        authRemoteFirestore: sl(),
      ));
  // sl.registerLazySingleton<ChatRepository>(
  //   () => ChatRepositoryImpl(chatRemoteDataSource: sl()),
  // );

  // sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
  //       homeRemoteDataSource: sl(),
  //     ));

  // sl.registerLazySingleton<DrawingBoardRepository>(
  //     () => DrawingBoardRepositoryImpl(
  //           drawingBoardRemoteDataSource: sl(),
  //         ));

  // DataSources
  sl.registerLazySingleton<AuthRemoteFirebaseAuth>(
      () => AuthRemoteFirebaseAuthImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRemoteFirestore>(
      () => AuthRemoteFirestoreImpl(sl()));
  // sl.registerLazySingleton<ChatRemoteDataSource>(
  //     () => ChatRemoteDataSourceImpl(remoteDatabase: sl()));
  // sl.registerLazySingleton<HomeRemoteDataSource>(
  //     () => HomeRemoteDataSourceImpl(remoteDatabase: sl()));
  // sl.registerLazySingleton<DrawingBoardRemoteDataSource>(
  //     () => DrawingBoardRemoteDataSourceImpl(remoteDatabase: sl()));

  // Services
  sl.registerLazySingleton<FirebaseAuthService>(
      () => RemoteAuthServiceImpl(FirebaseAuth.instance));
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl());
  sl.registerLazySingleton<RemoteDatabaseService>(
      () => RemoteDatabaseServiceImpl(FirebaseFirestore.instance));
}