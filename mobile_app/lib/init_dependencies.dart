import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_app/core/utils/firebase_options.dart';
import 'package:mobile_app/features/_auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mobile_app/features/_auth/data/repository/auth_repository.dart';
import 'package:mobile_app/features/_auth/domain/repository/iauth_repository.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_login.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_sign_up.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app/features/_user/domain/user_cases/logout.dart';
import 'package:mobile_app/features/camera/data/data_sources/camera_remote_data_source.dart';
import 'package:mobile_app/features/camera/data/repository/camera_repository.dart';
import 'package:mobile_app/features/camera/domain/repository/icamera_repository.dart';
import 'package:mobile_app/features/camera/domain/use_cases/get_classification.dart';
import 'package:mobile_app/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/_user/data/data_sources/user_profile_remote_data_source.dart';
import 'package:mobile_app/features/_user/data/repository/user_repository.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';
import 'package:mobile_app/features/_user/domain/user_cases/get_user_profile_data.dart';
import 'package:mobile_app/features/_user/domain/user_cases/update_user_profile_data.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;

  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => http.Client());

  _initAuth();
  _initUser();
  _initCamera();
  _initNavbar();
  _initSideMenu();
  _initEntryPoint();
}

void _initSideMenu() {
  serviceLocator.registerLazySingleton(
    () => SideMenuBloc(),
  );
}

void _initEntryPoint() {
  serviceLocator.registerLazySingleton(
    () => EntryPointBloc(),
  );
}

void _initNavbar() {
  serviceLocator.registerLazySingleton(
    () => NavbarBloc(),
  );
}

void _initCamera() {
  serviceLocator
    ..registerFactory<ICameraRemoteDataSource>(
      () => CameraRemoteDataSource(
        serviceLocator(),
      ),
    )
    ..registerFactory<ICameraRepository>(
      () => CameraRepository(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetClassification(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CameraBloc(
        getClassification: serviceLocator(),
      ),
    );
}

void _initUser() {
  serviceLocator
    ..registerFactory<IUserProfileRemoteDataSource>(
      () => UserProfileRemoteDataSource(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<IUserProfileRepository>(
      () => UserProfileRepository(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserProfileData(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUserProfileData(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => LogoutUseCase(
          serviceLocator(),
        ))
    ..registerLazySingleton(
      () => UserBloc(
        getUserProfile: serviceLocator(),
        updateUserProfile: serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<IAuthRemoteDataSource>(
      () => AuthRemoteDataSource(
        serviceLocator(),
      ),
    )
    ..registerFactory<IAuthRepository>(
      () => AuthRepository(
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
