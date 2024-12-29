part of 'camera_bloc.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

final class CameraInitial extends CameraState {}

final class CameraSucces extends CameraState {}

final class CameraFailure extends CameraState {}

final class CameraLoading extends CameraState {}
