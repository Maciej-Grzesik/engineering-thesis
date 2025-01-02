part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class GetUserProfile extends UserEvent {
  const GetUserProfile();
}

final class UpdateUserProfile extends UserEvent {
  final String email;
  final String name;

  const UpdateUserProfile({
    required this.email,
    required this.name,
  });
}

final class LogoutEvent extends UserEvent {}
