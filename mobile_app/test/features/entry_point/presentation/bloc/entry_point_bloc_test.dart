import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';

void main() {
  group('EntryPointBloc', () {
    late EntryPointBloc entryPointBloc;

    setUp(() {
      entryPointBloc = EntryPointBloc();
    });

    tearDown(() {
      entryPointBloc.close();
    });

    test('initial state is CameraPageOff', () {
      expect(entryPointBloc.state, CameraPageOff());
    });

    blocTest<EntryPointBloc, EntryPointState>(
      'emits [CameraPageOn] when ToggleCameraPage is added and initial state is CameraPageOff',
      build: () => entryPointBloc,
      act: (bloc) => bloc.add(ToggleCameraPage()),
      expect: () => [CameraPageOn()],
    );

    blocTest<EntryPointBloc, EntryPointState>(
      'emits [CameraPageOff] when ToggleCameraPage is added and initial state is CameraPageOn',
      build: () => entryPointBloc,
      seed: () => CameraPageOn(),
      act: (bloc) => bloc.add(ToggleCameraPage()),
      expect: () => [CameraPageOff()],
    );
  });
}