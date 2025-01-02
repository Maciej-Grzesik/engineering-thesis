import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/user_cases/update_user_profile_data.dart';
import 'package:mobile_app/features/_user/domain/user_cases/get_user_profile_data.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateUserProfile extends Mock implements UpdateUserProfileData {}

class MockGetUserProfile extends Mock implements GetUserProfileData {}

void main() {
  late UserBloc userBloc;
  late MockUpdateUserProfile mockUpdateUserProfile;

  setUp(() {
    mockUpdateUserProfile = MockUpdateUserProfile();
    userBloc = UserBloc(
      updateUserProfile: mockUpdateUserProfile,
      getUserProfile: MockGetUserProfile(),
    );
  });

  tearDown(() {
    userBloc.close();
  });

  blocTest<UserBloc, UserState>(
    'emits [UserLoading, UserSuccess] when UpdateUserProfile is added and succeeds',
    build: () {
      when(() => mockUpdateUserProfile(any())).thenAnswer(
        (_) async => Right(UserProfile(name: 'Test', email: 'test@example.com')),
      );
      return userBloc;
    },
    act: (bloc) => bloc.add(const UpdateUserProfile(name: 'Test', email: 'test@example.com')),
    expect: () => [
      UserLoading(),
      UserSuccess(UserProfile(name: 'Test', email: 'test@example.com')),
    ],
  );

  blocTest<UserBloc, UserState>(
    'emits [UserLoading, UserFailure] when UpdateUserProfile is added and fails',
    build: () {
      when(() => mockUpdateUserProfile(any())).thenAnswer(
        (_) async => Left(Failure('Server Failure')),
      );
      return userBloc;
    },
    act: (bloc) => bloc.add(const UpdateUserProfile(name: 'Test', email: 'test@example.com')),
    expect: () => [
      UserLoading(),
      const UserFailure('Server Failure'),
    ],
  );

  blocTest<UserBloc, UserState>(
    'emits [LogoutState] when LogoutEvent is added',
    build: () => userBloc,
    act: (bloc) => bloc.add(LogoutEvent()),
    expect: () => [
      LogoutState(),
    ],
  );
}