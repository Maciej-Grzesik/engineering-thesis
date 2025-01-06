import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/common/widgets/loader.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app/features/_auth/presentation/widgets/auth_input.dart';
import 'package:mobile_app/features/_auth/presentation/pages/register_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(AuthSignup(email: '', password: ''));
  });
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
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
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: const RegisterPage(),
      ),
    );
  }

  testWidgets('displays welcome and create account texts',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pump(const Duration(seconds: 1));
    expect(find.text(l10n.welcome), findsOneWidget);
    expect(find.text(l10n.create_account), findsOneWidget);
  });

  testWidgets('displays email, password, and confirm password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(AuthInput), findsNWidgets(3));
  });

  testWidgets('displays register button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(l10n.register), findsOneWidget);
  });

  testWidgets('displays social media icons', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
    expect(find.byIcon(Icons.apple), findsOneWidget);
    expect(find.byIcon(Icons.facebook), findsOneWidget);
  });

  testWidgets('displays already have an account text and sign in button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(l10n.already_have_account), findsOneWidget);
    expect(find.text(l10n.sign_in), findsOneWidget);
  });

  testWidgets('shows loader on AuthLoading state', (WidgetTester tester) async {
    whenListen(mockAuthBloc, Stream.fromIterable([AuthLoading()]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Loader), findsOneWidget);
  });

  testWidgets('calls AuthSignup event when form is valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(AuthInput).at(0), 'test@example.com');
    await tester.enterText(find.byType(AuthInput).at(1), 'password123');
    await tester.enterText(find.byType(AuthInput).at(2), 'password123');
    await tester.tap(find.text('Register'));
    await tester.pump();

    verifyNever(() => mockAuthBloc
        .add(AuthSignup(email: 'test@example.com', password: 'password123')));
  });

  testWidgets('does not call AuthSignup event when form is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(AuthInput).at(0), '');
    await tester.enterText(find.byType(AuthInput).at(1), 'password123');
    await tester.enterText(find.byType(AuthInput).at(2), 'password123');
    await tester.tap(find.text('Register'));
    await tester.pump();

    verifyNever(() => mockAuthBloc.add(any()));
  });
}
