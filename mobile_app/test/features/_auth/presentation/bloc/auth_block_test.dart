import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_login.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_sign_up.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';

class MockUserLogin extends Mock implements UserLogin {}
class MockUserSignUp extends Mock implements UserSignUp {}

class FakeUserLoginParams extends Fake implements UserLoginParams {}

void main() {
  late AuthBloc authBloc;
  late MockUserLogin mockUserLogin;
  late MockUserSignUp mockUserSignUp;

  setUpAll(() {
    registerFallbackValue(FakeUserLoginParams());
  });

  setUp(() {
    mockUserLogin = MockUserLogin();
    mockUserSignUp = MockUserSignUp();
    authBloc = AuthBloc(userLogin: mockUserLogin, userSignUp: mockUserSignUp);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';
  final tUser = User(id: '1', email: tEmail);

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] when AuthLogin is added and login is successful',
    build: () {
      when(() => mockUserLogin(any())).thenAnswer((_) async => Right(tUser));
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthLogin(email: tEmail, password: tPassword)),
    expect: () => [AuthLoading(), AuthSuccess(tUser)],
    verify: (_) {
      verify(() => mockUserLogin(const UserLoginParams(email: tEmail, password: tPassword))).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure] when AuthLogin is added and login fails',
    build: () {
      when(() => mockUserLogin(any())).thenAnswer((_) async => Left(Failure('Login failed')));
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthLogin(email: tEmail, password: tPassword)),
    expect: () => [AuthLoading(), const AuthFailure('Login failed')],
    verify: (_) {
      verify(() => mockUserLogin(const UserLoginParams(email: tEmail, password: tPassword))).called(1);
    },
  );
}