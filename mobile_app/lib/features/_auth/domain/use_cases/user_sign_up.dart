import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';
import 'package:mobile_app/features/_auth/domain/repository/iauth_repository.dart';

class UserSignUp implements UseCase {
  final IAuthRepository _authRepository;

  UserSignUp(this._authRepository);

  @override
  Future<Either<Failure, User>> call(params) async {
    return await _authRepository.signupWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String email;
  final String password;

  UserSignupParams({
    required this.email,
    required this.password,
  });
}
