part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserSuccess extends UserState {
  final UserProfile userProfile;

  const UserSuccess(this.userProfile);
}

final class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);
}

final class LogoutState extends UserState {}
