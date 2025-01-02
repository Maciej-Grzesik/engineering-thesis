part of 'camera_bloc.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

final class ClassificationEvent extends CameraEvent {
  final String b64Video;

  const ClassificationEvent({required this.b64Video});
}

class StartRecordingEvent extends CameraEvent {}

class StopRecordingEvent extends CameraEvent {}
