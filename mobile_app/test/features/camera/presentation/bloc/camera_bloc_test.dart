import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_app/core/error/error.dart';
import 'package:mobile_app/features/camera/domain/entities/classification.dart';
import 'package:mobile_app/features/camera/domain/use_cases/get_classification.dart';
import 'package:mobile_app/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetClassification extends Mock implements GetClassification {}

class FakeVideoDataParams extends Fake implements VideoDataParams {}

void main() {
  late CameraBloc cameraBloc;
  late MockGetClassification mockGetClassification;

  setUp(() {
    mockGetClassification = MockGetClassification();
    cameraBloc = CameraBloc(getClassification: mockGetClassification);
  });

  setUpAll(() {
    registerFallbackValue(FakeVideoDataParams());
  });

  tearDown(() {
    cameraBloc.close();
  });

  group('CameraBloc', () {
    blocTest<CameraBloc, CameraState>(
      'emits [CameraLoading, CameraSuccess] when _onGetClassification is successful',
      build: () {
        when(() => mockGetClassification(any())).thenAnswer(
          (_) async => const Right(Classification(word: 'example')),
        );
        return cameraBloc;
      },
      act: (bloc) =>
          bloc.add(const ClassificationEvent(b64Video: 'test_video')),
      expect: () => [
        CameraLoading(),
        const CameraSucces(Classification(word: 'example')),
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'emits [CameraLoading, CameraFailure] when _onGetClassification fails',
      build: () {
        when(() => mockGetClassification(any())).thenAnswer(
          (_) async => Left(Failure('Error')),
        );
        return cameraBloc;
      },
      act: (bloc) =>
          bloc.add(const ClassificationEvent(b64Video: 'test_video')),
      expect: () => [
        CameraLoading(),
        const CameraFailure('Error'),
      ],
    );

    blocTest<CameraBloc, CameraState>(
      'emits [CameraRecording] when _onStartRecording is called',
      build: () => cameraBloc,
      act: (bloc) => bloc.add(StartRecordingEvent()),
      expect: () => [CameraRecording()],
    );

    blocTest<CameraBloc, CameraState>(
      'emits [CameraNotRecording] when _onStopRecording is called',
      build: () => cameraBloc,
      act: (bloc) => bloc.add(StopRecordingEvent()),
      expect: () => [CameraNotRecording()],
    );
  });
}
