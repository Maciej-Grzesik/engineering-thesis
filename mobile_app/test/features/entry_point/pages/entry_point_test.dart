import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/camera/presentation/pages/camera.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/menu_button.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/pages/entry_point.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockEntryPointBloc extends MockBloc<EntryPointEvent, EntryPointState> implements EntryPointBloc {}

class MockNavbarBloc extends MockBloc<NavbarEvent, NavbarState> implements NavbarBloc {}

class MockSideMenuBloc extends MockBloc<SideMenuEvent, SideMenuState> implements SideMenuBloc {}

void main() {
  late MockEntryPointBloc mockEntryPointBloc;
  late MockNavbarBloc mockNavbarBloc;
  late MockSideMenuBloc mockSideMenuBloc;

  setUp(() {
    mockEntryPointBloc = MockEntryPointBloc();
    mockNavbarBloc = MockNavbarBloc();
    mockSideMenuBloc = MockSideMenuBloc();
  });

  tearDown(() {
    mockEntryPointBloc.close();
    mockNavbarBloc.close();
    mockSideMenuBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EntryPointBloc>.value(value: mockEntryPointBloc),
          BlocProvider<NavbarBloc>.value(value: mockNavbarBloc),
          BlocProvider<SideMenuBloc>.value(value: mockSideMenuBloc),
        ],
        child: const EntryPoint(),
      ),
    );
  }

  testWidgets('initial state of EntryPoint', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());
    when(() => mockNavbarBloc.state).thenReturn(const PushPageSuccess([HomePage()]));
    when(() => mockSideMenuBloc.state).thenReturn(SideMenuCollapsed());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MenuButton), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('menu button pressed', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());
    when(() => mockNavbarBloc.state).thenReturn(const PushPageSuccess([HomePage()]));
    when(() => mockSideMenuBloc.state).thenReturn(SideMenuCollapsed());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(MenuButton));
    await tester.pump(const Duration(milliseconds: 300));

    verify(() => mockSideMenuBloc.add(OnMenuToggle())).called(1);
  });

  testWidgets('side menu toggled', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());
    when(() => mockNavbarBloc.state).thenReturn(const PushPageSuccess([HomePage()]));
    whenListen(mockSideMenuBloc, Stream.fromIterable([SideMenuExtended(), SideMenuCollapsed()]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MenuButton), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byType(MenuButton));
    await tester.pump(const Duration(milliseconds: 300));

    verify(() => mockSideMenuBloc.add(OnMenuToggle())).called(1);
  });

  testWidgets('NavbarBloc state changes', (WidgetTester tester) async {
    when(() => mockEntryPointBloc.state).thenReturn(CameraPageOff());
    whenListen(mockNavbarBloc, Stream.fromIterable([const PushPageSuccess([HomePage()]), const GoBackSuccess([HomePage()])]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);

    verify(() => mockNavbarBloc.add(const PushPage(HomePage()))).called(1);
  });

  testWidgets('EntryPointBloc state changes', (WidgetTester tester) async {
    whenListen(mockEntryPointBloc, Stream.fromIterable([CameraPageOff(), CameraPageOn()]));
    when(() => mockNavbarBloc.state).thenReturn(const PushPageSuccess([HomePage()]));
    when(() => mockSideMenuBloc.state).thenReturn(SideMenuCollapsed());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CameraPage), findsOneWidget);
  });
}