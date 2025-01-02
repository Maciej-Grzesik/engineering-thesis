import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/core/use_case/use_case.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';
import 'package:mobile_app/features/_auth/domain/repository/iauth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final IAuthRepository _authRepository;

  UserLogin(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return _authRepository.loginWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  const UserLoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
