import 'package:mobile_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String password,
  });
}
