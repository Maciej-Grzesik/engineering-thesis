import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/error/exception.dart';
import 'package:mobile_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/domain/entities/user.dart';
import 'package:mobile_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signupWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on ServiceException catch (e) {
      return left(Failure(e.message));
    } on fb.FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'An error occurred'));
    } catch (e) {
      return left(Failure('An error occurred'));
    }
  }
}
