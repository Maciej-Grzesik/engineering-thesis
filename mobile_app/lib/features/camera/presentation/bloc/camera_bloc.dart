import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_app/features/camera/domain/entities/classification.dart';
import 'package:mobile_app/features/camera/domain/use_cases/get_classification.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final GetClassification _getClassification;

  CameraBloc({
    required GetClassification getClassification,
  })  : _getClassification = getClassification,
        super(CameraInitial()) {
    on<ClassificationEvent>(_onGetClassification);
    on<StartRecordingEvent>(_onStartRecording);
    on<StopRecordingEvent>(_onStopRecording);
  }

  void _onGetClassification(
      ClassificationEvent event, Emitter<CameraState> emit) async {
    emit(CameraLoading());
    print("getting classification");
    final response = await _getClassification(
      VideoDataParams(
        b64Video: event.b64Video,
      ),
    );
    print(response);
    response.fold(
      (l) => emit(CameraFailure(l.message)),
      (classification) => emit(CameraSucces(classification)),
    );
  }

  void _onStartRecording(StartRecordingEvent event, Emitter<CameraState> emit) {
    emit(CameraRecording());
  }

  void _onStopRecording(StopRecordingEvent event, Emitter<CameraState> emit) {
    emit(CameraNotRecording());
  }
}
