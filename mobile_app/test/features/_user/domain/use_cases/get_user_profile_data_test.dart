import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/features/_user/domain/user_cases/get_user_profile_data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/repository/iuser_profile_repository.dart';

class MockUserProfileRepository extends Mock implements IUserProfileRepository {}

void main() {
  late GetUserProfileData useCase;
  late MockUserProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockUserProfileRepository();
    useCase = GetUserProfileData(mockRepository);
  });

  final tUserProfile = UserProfile(
    name: 'Test User',
    email: 'test@example.com',
  );

  test('should return UserProfile when repository call is successful', () async {
    when(() => mockRepository.getUserProfileData())
        .thenAnswer((_) async => Right(tUserProfile));

    final result = await useCase();

    expect(result, Right(tUserProfile));
    verify(() => mockRepository.getUserProfileData()).called(1);
  });

  test('should return Failure when repository call fails', () async {
    final failure = Failure('Error fetching user profile');
    when(() => mockRepository.getUserProfileData())
        .thenAnswer((_) async => Left(failure));

    final result = await useCase();
    expect(result, Left(failure));
    verify(() => mockRepository.getUserProfileData()).called(1);
  });

  test('should call repository method exactly once', () async {
    when(() => mockRepository.getUserProfileData())
        .thenAnswer((_) async => Right(tUserProfile));

    await useCase();
    await useCase();
    await useCase();

    verify(() => mockRepository.getUserProfileData()).called(3);
  });
}