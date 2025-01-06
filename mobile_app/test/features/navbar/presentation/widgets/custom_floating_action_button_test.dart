import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/widgets/custom_floating_action_button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockEntryPointBloc extends MockBloc<EntryPointEvent, EntryPointState>
    implements EntryPointBloc {}

void main() {
  late MockEntryPointBloc mockEntryPointBloc;

  setUp(() {
    mockEntryPointBloc = MockEntryPointBloc();
  });

  tearDown(() {
    mockEntryPointBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: BlocProvider<EntryPointBloc>.value(
          value: mockEntryPointBloc,
          child: const CustomFloatingActionButton(),
        ),
      ),
    );
  }

  testWidgets('initial state of CustomFloatingActionButton',
      (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(EntryPointInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('button press functionality', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(EntryPointInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    verify(() => mockEntryPointBloc.add(ToggleCameraPage())).called(1);
  });

  testWidgets('icon changes based on state', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOn());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.clear), findsOneWidget);

    when(() => mockEntryPointBloc.state).thenReturn(EntryPointInitial());
    mockEntryPointBloc.emit(EntryPointInitial());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}
