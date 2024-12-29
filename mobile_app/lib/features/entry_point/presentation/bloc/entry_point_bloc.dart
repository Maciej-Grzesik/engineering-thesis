import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'entry_point_event.dart';
part 'entry_point_state.dart';

class EntryPointBloc extends Bloc<EntryPointEvent, EntryPointState> {
  EntryPointBloc() : super(EntryPointInitial()) {
    on<EntryPointEvent>((event, emit) {
      
    });
  }
}
