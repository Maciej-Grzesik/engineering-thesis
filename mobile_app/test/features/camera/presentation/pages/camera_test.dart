import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';
import 'package:mobile_app/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:mobile_app/features/camera/presentation/pages/camera.dart';
import 'package:mobile_app/features/camera/presentation/widgets/countdown_overlay.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';

class MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

class MockNavbarBloc extends MockBloc<NavbarEvent, NavbarState>
    implements NavbarBloc {}

class MockCameraController extends Mock implements CameraController {}

void main() {
  late MockCameraBloc mockCameraBloc;
  late MockNavbarBloc mockNavbarBloc;
  late MockCameraController mockCameraController;

  setUp(() {
    mockCameraBloc = MockCameraBloc();
    mockNavbarBloc = MockNavbarBloc();
    mockCameraController = MockCameraController();

    when(() => mockCameraController.value).thenReturn(
      const CameraValue.uninitialized(
        CameraDescription(
          name: 'MockCamera',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0,
        ),
      ),
    );
    when(() => mockCameraController.initialize()).thenAnswer((_) async {});
    when(() => mockNavbarBloc.state).thenReturn(NavbarInitial());
  });

  tearDown(() {
    mockCameraBloc.close();
    mockNavbarBloc.close();
  });

  Widget createWidgetUnderTest(MockCameraBloc mockCameraBloc) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>.value(value: mockCameraBloc),
        BlocProvider<NavbarBloc>.value(value: mockNavbarBloc),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return const CameraPage();
            },
          ),
        ),
      ),
    );
  }

  testWidgets('displays loader when camera is not initialized',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(mockCameraBloc));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(Loader), findsOneWidget);
  });

  testWidgets('displays CountdownOverlay when CameraRecording state is emitted',
      (WidgetTester tester) async {
    whenListen(
      mockCameraBloc,
      Stream.fromIterable([CameraRecording()]),
      initialState: CameraRecording(),
    );

    print('mockCameraBloc: ${mockCameraBloc.state}');
    await tester.pumpWidget(createWidgetUnderTest(mockCameraBloc));
    await tester.pump();
    print('mockCameraBloc: ${mockCameraBloc.state}');

    expect(find.byType(CountdownOverlay), findsOneWidget);
  });

  testWidgets(
      'calls onCountdownComplete and triggers ClassificationEvent and StopRecordingEvent',
      (WidgetTester tester) async {
    whenListen(
      mockCameraBloc,
      Stream.fromIterable([CameraRecording()]),
      initialState: CameraRecording(),
    );

    print('mockCameraBloc: ${mockCameraBloc.state}');
    await tester.pumpWidget(createWidgetUnderTest(mockCameraBloc));
    await tester.pump();
    print('mockCameraBloc: ${mockCameraBloc.state}');
    final countdownOverlay = find.byType(CountdownOverlay);
    expect(countdownOverlay, findsOneWidget);

    final countdownOverlayWidget =
        tester.widget<CountdownOverlay>(countdownOverlay);
    countdownOverlayWidget.onCountdownComplete();

    verify(() => mockCameraBloc.add(any(that: isA<ClassificationEvent>())))
        .called(1);
    verify(() => mockCameraBloc.add(any(that: isA<StopRecordingEvent>())))
        .called(1);
  });
}
