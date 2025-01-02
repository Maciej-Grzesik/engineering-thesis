import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/common/models/language.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/localization_bloc/localization_bloc.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:mobile_app/features/_settings/presentation/pages/settings_page.dart';
import 'package:mobile_app/l10n/l10n.dart';

void main() {
  group('SettingsPage', () {
    late ThemeBloc themeBloc;
    late LocalizationBloc localizationBloc;

    setUp(() {
      themeBloc = ThemeBloc();
      localizationBloc = LocalizationBloc();
    });

    testWidgets('should display theme switch', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LocalizationBloc>.value(value: localizationBloc),
          ],
          child: const MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SettingsPage(),
            ),
          ),
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.textContaining(l10n.theme));
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should display language buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LocalizationBloc>.value(value: localizationBloc),
          ],
          child: const MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SettingsPage(),
            ),
          ),
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.text(l10n.language));
      await tester.pumpAndSettle();

      expect(find.text(l10n.english), findsOneWidget);
      expect(find.text(l10n.polish), findsOneWidget);
    });

    testWidgets('should change theme when switch is toggled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LocalizationBloc>.value(value: localizationBloc),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SettingsPage(),
            ),
          ),
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Expand the StyledExpansionTile
      await tester.tap(find.textContaining(l10n.theme));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(themeBloc.state, ThemeMode.dark);
    });
    testWidgets('should change language when button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LocalizationBloc>.value(value: localizationBloc),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SettingsPage(),
            ),
          ),
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.textContaining(l10n.language));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.english));
      await tester.pump();

      expect(localizationBloc.state.selectedLanguage, Language.en);

      await tester.tap(find.text(l10n.polish));
      await tester.pump();

      expect(localizationBloc.state.selectedLanguage, Language.en);
    });
  });
}
