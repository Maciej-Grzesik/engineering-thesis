import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_sign_up.dart';
import 'package:mobile_app/features/_auth/domain/repository/iauth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UserSignUp useCase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
        UserSignupParams(email: 'test@example.com', password: 'password'));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserSignUp(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';
  final tUser = User(id: '1', email: tEmail);

  test('should return User when sign-up is successful', () async {
    when(() => mockAuthRepository.signupWithEmailPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Right(tUser));


    final result = await useCase(
        UserSignupParams(email: tEmail, password: tPassword));

    expect(result, Right(tUser));
    verify(() => mockAuthRepository.signupWithEmailPassword(
        email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when sign-up fails', () async {
    when(() => mockAuthRepository.signupWithEmailPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Left(Failure('Sign-up failed')));

    final result = await useCase(
        UserSignupParams(email: tEmail, password: tPassword));

    expect(result, Left<Failure, User>(Failure('Sign-up failed')));
    verify(() => mockAuthRepository.signupWithEmailPassword(
        email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
