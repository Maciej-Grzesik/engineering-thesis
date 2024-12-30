import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/features/_auth/domain/use_cases/user_login.dart';
import 'package:mobile_app/features/_auth/domain/repository/iauth_repository.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/features/_auth/domain/entities/user.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UserLogin useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserLogin(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';
  final tUser = User(id: '1', email: tEmail);

  test('should return User when login is successful', () async {
    // arrange
    when(() => mockAuthRepository.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Right(tUser));

    // act
    final result = await useCase(
        const UserLoginParams(email: tEmail, password: tPassword));

    // assert
    expect(result, Right(tUser));
    verify(() => mockAuthRepository.loginWithEmailPassword(
        email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when login fails', () async {
    when(() => mockAuthRepository.loginWithEmailPassword(
          email: tEmail,
          password: tPassword,
        )).thenAnswer((_) async => Left(Failure('Login failed')));

    final result = await useCase(
        const UserLoginParams(email: tEmail, password: tPassword));

    expect(result, Left<Failure, User>(Failure('Login failed')));
    verify(() => mockAuthRepository.loginWithEmailPassword(
        email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
