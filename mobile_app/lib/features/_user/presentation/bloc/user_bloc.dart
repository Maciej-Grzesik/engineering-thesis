import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/domain/user_cases/get_user_profile_data.dart';
import 'package:mobile_app/features/_user/domain/user_cases/update_user_profile_data.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileData _getUserProfile;
  final UpdateUserProfileData _updateUserProfile;

  UserBloc({
    required GetUserProfileData getUserProfile,
    required UpdateUserProfileData updateUserProfile,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        super(UserInitial()) {
    on<GetUserProfile>(
      _onGetUserProfile,
    );
    on<UpdateUserProfile>(
      _onUpdateUserProfile,
    );
    on<LogoutEvent>(
      _onLogout,
    );
  }

  void _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    emit(
      LogoutState(),
    );
  }

  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final response = await _updateUserProfile(UserProfileParams(
      email: event.email,
      name: event.name,
    ));
    print(response);
    response.fold(
      (l) => emit(UserFailure(l.message)),
      (r) => emit(UserSuccess(r)),
    );
  }

  void _onGetUserProfile(GetUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final response = await _getUserProfile();

    response.fold(
      (l) => emit(UserFailure(l.message)),
      (r) => emit(UserSuccess(r)),
    );
  }
}
