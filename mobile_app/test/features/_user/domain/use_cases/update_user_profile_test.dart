import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';
import 'package:mobile_app/features/_user/domain/user_cases/update_user_profile_data.dart';

class MockUserProfileRepository extends Mock
    implements IUserProfileRepository {}

void main() {
  late UpdateUserProfileData useCase;
  late MockUserProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserProfileParams(email: '', name: ''));
  });

  setUp(() {
    mockRepository = MockUserProfileRepository();
    useCase = UpdateUserProfileData(mockRepository);
  });

  final tUserProfile =
      UserProfile(name: 'Test User', email: 'test@example.com');
  final tParams = UserProfileParams(
    email: 'test@example.com',
    name: 'Test User',
  );

  group('UpdateUserProfileData', () {
    test('should return UserProfile when update is successful', () async {
      // arrange
      when(() => mockRepository.updateUserProfileData(
            email: any(named: 'email'),
            name: any(named: 'name'),
          )).thenAnswer((_) async => Right(tUserProfile));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tUserProfile));
      verify(() => mockRepository.updateUserProfileData(
            email: tParams.email,
            name: tParams.name,
          )).called(1);
    });

    test('should return Failure when update fails', () async {
      // arrange
      final tFailure = Failure('Error updating user profile');
      when(() => mockRepository.updateUserProfileData(
            email: any(named: 'email'),
            name: any(named: 'name'),
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(tFailure));
      verify(() => mockRepository.updateUserProfileData(
            email: tParams.email,
            name: tParams.name,
          )).called(1);
    });

    test('should call update multiple times with correct params', () async {
      // arrange
      when(() => mockRepository.updateUserProfileData(
            email: any(named: 'email'),
            name: any(named: 'name'),
          )).thenAnswer((_) async => Right(tUserProfile));

      // act
      await useCase(tParams);
      await useCase(tParams);

      // assert
      verify(() => mockRepository.updateUserProfileData(
            email: tParams.email,
            name: tParams.name,
          )).called(2);
    });
  });
}
