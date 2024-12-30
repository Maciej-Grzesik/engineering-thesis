part of 'camera_bloc.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

final class CameraInitial extends CameraState {}

final class CameraSucces extends CameraState {
  final Classification classification;

  const CameraSucces(this.classification);
}

final class CameraFailure extends CameraState {
  final String message;

  const CameraFailure(this.message);
}

final class CameraLoading extends CameraState {}
final class CameraRecording extends CameraState {}
final class CameraNotRecording extends CameraState {}
