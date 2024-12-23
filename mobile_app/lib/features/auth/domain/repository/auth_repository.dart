import 'package:mobile_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String password,
  });
}
