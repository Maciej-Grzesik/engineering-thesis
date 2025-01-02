import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';
import 'package:mobile_app/features/_user/presentation/pages/user_profile.dart'
    as up;
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

void main() {
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  tearDown(() {
    mockUserBloc.close();
  });

  Widget createWidgetUnderTest(MockUserBloc mockUserBloc) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<UserBloc>.value(
        value: mockUserBloc,
        child: const up.UserProfile(),
      ),
    );
  }

  testWidgets('displays loading indicator when state is UserLoading',
      (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserLoading());

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays user profile when state is UserSuccess',
      (tester) async {
    final userProfile = UserProfile(name: 'Test', email: 'test@example.com');
    when(() => mockUserBloc.state).thenReturn(UserSuccess(userProfile));

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pump(const Duration(milliseconds: 100));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.user_profile), findsOneWidget);
    expect(find.text("${l10n.name}: Test"), findsOneWidget);
    expect(find.text("${l10n.email}: test@example.com"), findsOneWidget);
  });

  testWidgets('displays error message when state is UserFailure',
      (tester) async {
    when(() => mockUserBloc.state)
        .thenReturn(const UserFailure("Failed to load data"));

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Failed to load data'), findsOneWidget);
  });

  testWidgets('displays loading text when state is initial', (tester) async {
    when(() => mockUserBloc.state).thenReturn(UserInitial());

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pump(const Duration(milliseconds: 100));
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.loading), findsOneWidget);
  });

  testWidgets('shows edit dialog when edit button is pressed', (tester) async {
    final userProfile = UserProfile(name: 'test', email: 'test@example.com');
    when(() => mockUserBloc.state).thenReturn(UserSuccess(userProfile));

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('updates user profile when save button is pressed in edit dialog',
      (tester) async {
    final userProfile = UserProfile(name: 'test', email: 'test@example.com');
    when(() => mockUserBloc.state).thenReturn(UserSuccess(userProfile));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (_) => mockUserBloc,
          ),
        ],
        child: createWidgetUnderTest(mockUserBloc),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byType(TextField).at(0), 'test1');
    await tester.enterText(find.byType(TextField).at(1), 'test1@example.com');

    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(milliseconds: 100));

    verify(() => mockUserBloc.add(
            const UpdateUserProfile(name: 'test1', email: 'test1@example.com')))
        .called(1);
  });
}
