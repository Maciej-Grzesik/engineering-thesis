import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_app/core/utils/firebase_options.dart';
import 'package:mobile_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mobile_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/use_cases/user_login.dart';
import 'package:mobile_app/features/auth/domain/use_cases/user_sign_up.dart';
import 'package:mobile_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;

  serviceLocator.registerLazySingleton(() => firebaseAuth);
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
      ),
    );
}
