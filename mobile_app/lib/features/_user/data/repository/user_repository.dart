import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/error/exception.dart';
import 'package:mobile_app/features/_user/data/data_sources/user_profile_remote_data_source.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';

class UserProfileRepository implements IUserProfileRepository {
  final IUserProfileRemoteDataSource remoteDataSource;

  UserProfileRepository(this.remoteDataSource);

  Future<Either<Failure, UserProfile>> _getUserProfile(
    Future<UserProfile> Function() fn,
  ) async {
    try {
      final userProfile = await fn();
      return right(userProfile);
    } on ServiceException catch (e) {
      return left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'An error occurred'));
    } catch (e) {
      return left(Failure('An error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfileData() async {
    return _getUserProfile(
      () async => await remoteDataSource.getUserProfile(),
    );
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfileData({
    required String name,
    required String email,
  }) async {
    return _getUserProfile(
      () async => await remoteDataSource.updateUserProfile(
        name: name,
        email: email,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return right(null);
    } catch (e) {
      return left(Failure('An error occurred'));
    }
  }
}
