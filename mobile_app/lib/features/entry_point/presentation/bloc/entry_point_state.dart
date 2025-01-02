part of 'entry_point_bloc.dart';

sealed class EntryPointState extends Equatable {
  const EntryPointState();
  
  @override
  List<Object> get props => [];
}

final class EntryPointInitial extends EntryPointState {}

final class CameraPageOn extends EntryPointState {}
final class CameraPageOff extends EntryPointState {}
