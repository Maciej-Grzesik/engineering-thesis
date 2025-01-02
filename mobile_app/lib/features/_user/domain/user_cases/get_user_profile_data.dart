import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';

class GetUserProfileData implements UseCaseNoParams {
  final IUserProfileRepository _userRepository;

  GetUserProfileData(this._userRepository);

  @override
  Future<Either<Failure, UserProfile>> call() async {
    return await _userRepository.getUserProfileData();
  }
}



