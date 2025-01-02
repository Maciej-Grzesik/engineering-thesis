import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';

class UpdateUserProfileData implements UseCase {
  final IUserProfileRepository _userRepository;

  UpdateUserProfileData(this._userRepository);

  @override
  Future<Either<Failure, UserProfile>> call(params) async {
    return await _userRepository.updateUserProfileData(
      email: params.email,
      name: params.name,
    );
  }
}

class UserProfileParams {
  final String email;
  final String name;

  UserProfileParams({
    required this.email,
    required this.name,
  });
}
