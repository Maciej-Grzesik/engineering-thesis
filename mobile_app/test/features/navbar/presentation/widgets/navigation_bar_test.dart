import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_app/features/navbar/presentation/widgets/navigation_bar.dart';

class MockEntryPointBloc extends MockBloc<EntryPointEvent, EntryPointState> implements EntryPointBloc {}

class MockNavbarBloc extends MockBloc<NavbarEvent, NavbarState> implements NavbarBloc {}

void main() {
  late MockEntryPointBloc mockEntryPointBloc;
  late MockNavbarBloc mockNavbarBloc;

  setUp(() {
    mockEntryPointBloc = MockEntryPointBloc();
    mockNavbarBloc = MockNavbarBloc();
  });

  tearDown(() {
    mockEntryPointBloc.close();
    mockNavbarBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EntryPointBloc>.value(value: mockEntryPointBloc),
          BlocProvider<NavbarBloc>.value(value: mockNavbarBloc),
        ],
        child: const CustomNavigationBar(),
      ),
    );
  }

  testWidgets('initial state of CustomNavigationBar', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.not_started_outlined), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('back button pressed', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockNavbarBloc.add(GoBack())).called(1);
  });

  testWidgets('start recording button pressed when not on camera page', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.not_started_outlined));
    await tester.pump(const Duration(seconds: 1));

  });

  testWidgets('start recording button pressed when on camera page', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOn());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.not_started_outlined));
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockNavbarBloc.add(SendClassificationEvent())).called(1);
  });
}