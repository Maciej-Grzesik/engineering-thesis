import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'entry_point_event.dart';
part 'entry_point_state.dart';

class EntryPointBloc extends Bloc<EntryPointEvent, EntryPointState> {
  EntryPointBloc() : super(CameraPageOff()) {
    on<ToggleCameraPage>(_onToggleCameraPage);
  }

  void _onToggleCameraPage(
      ToggleCameraPage event, Emitter<EntryPointState> emit) async {
    if (state is CameraPageOff) {
      emit(CameraPageOn());
    } else {
      emit(CameraPageOff());
    }
  }
}
