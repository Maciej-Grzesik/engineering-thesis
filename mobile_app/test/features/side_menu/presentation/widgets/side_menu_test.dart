import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/info_card.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/side_menu.dart';
import 'package:mobile_app/features/side_menu/presentation/widgets/side_menu_tile.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockNavbarBloc extends MockBloc<NavbarEvent, NavbarState>
    implements NavbarBloc {}

class MockSideMenuBloc extends MockBloc<SideMenuEvent, SideMenuState>
    implements SideMenuBloc {}


void main() {
  late MockUserBloc mockUserBloc;
  late MockNavbarBloc mockNavbarBloc;
  late MockSideMenuBloc mockSideMenuBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
    mockNavbarBloc = MockNavbarBloc();
    mockSideMenuBloc = MockSideMenuBloc();
  });

  tearDown(() {
    mockUserBloc.close();
    mockNavbarBloc.close();
    mockSideMenuBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
          BlocProvider<NavbarBloc>.value(value: mockNavbarBloc),
          BlocProvider<SideMenuBloc>.value(value: mockSideMenuBloc),
        ],
        child: const SideMenu(),
      ),
    );
  }

  testWidgets('initial state of SideMenu', (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(InfoCard), findsOneWidget);
    expect(find.byType(SideMenuTile), findsNWidgets(4));
  });

  testWidgets('logout functionality', (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Logout'));
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockUserBloc.add(LogoutEvent())).called(1);
    verify(() => mockSideMenuBloc.add(OnMenuToggle())).called(1);
  });

  testWidgets('menu item selection and navigation',
      (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Home'));
    await tester.pump(const Duration(seconds: 1));

    verify(() => mockNavbarBloc.add(PushPage(any()))).called(1);
    verify(() => mockSideMenuBloc.add(OnMenuToggle())).called(1);
  });
}
