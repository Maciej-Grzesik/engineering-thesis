part of 'entry_point_bloc.dart';

sealed class EntryPointEvent extends Equatable {
  const EntryPointEvent();

  @override
  List<Object> get props => [];
}

final class ToggleCameraPage extends EntryPointEvent {}