import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/common/widgets/exlamation_widget.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/_user/domain/entities/user_profile.dart';

class MockUserBloc extends Mock implements UserBloc {
  @override
  Stream<UserState> get stream => const Stream.empty();
}

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
      child: const HomePage(),
    ),
  );
}

void main() {
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  testWidgets('HomePage renders welcome text correctly',
      (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserInitial());

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.welcome), findsOneWidget);
    expect(find.text(l10n.home_page), findsOneWidget);
  });

  testWidgets(
      'HomePage shows loading indicator when UserLoading state is emitted',
      (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(UserLoading());

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'HomePage shows exclamation widget when UserFailure state is emitted',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(() => mockUserBloc.state)
            .thenReturn(const UserFailure('Error message'));

        await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));
        await tester.pump();

        expect(find.byType(ExlamationWidget), findsOneWidget);
      });
    },
  );

  testWidgets('HomePage shows empty widget when UserSuccess state is emitted',
      (WidgetTester tester) async {
    when(() => mockUserBloc.state).thenReturn(
        UserSuccess(UserProfile(email: 'test@example.com', name: 'Test User')));

    await tester.pumpWidget(createWidgetUnderTest(mockUserBloc));

    expect(find.byType(SizedBox), findsNWidgets(2));
  });
}
