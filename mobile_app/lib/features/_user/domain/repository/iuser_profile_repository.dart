import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';

abstract interface class IUserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfileData();

  Future<Either<Failure, UserProfile>> updateUserProfileData({
    required String name,
    required String email,
  });

  Future<Either<Failure, void>> logout();
}
