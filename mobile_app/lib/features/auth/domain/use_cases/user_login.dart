import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/auth/domain/entities/user.dart';
import 'package:mobile_app/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository _authRepository;

  UserLogin(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return _authRepository.loginWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
