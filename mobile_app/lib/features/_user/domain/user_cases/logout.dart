import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';

class LogoutUseCase implements UseCaseNoParams {
  final IUserProfileRepository _userRepository;

  LogoutUseCase(this._userRepository);

  @override
  Future<Either<Failure, void>> call() async {
     return await _userRepository.logout();
  }
}
