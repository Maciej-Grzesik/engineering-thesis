import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card_arrows.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

class MockPageController extends Mock implements PageController {}

void main() {
  const screenWidth = 1080.0;
  const screenHeight = 1920.0;
  const padding = 16.0;
  const currentPage = 0;
  const pageCount = 3;

  late MockPageController mockPageController;

  setUp(() {
    mockPageController = MockPageController();
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
      home: Scaffold(
        body: AboutCard(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          padding: padding,
          currentPage: currentPage,
          pageCount: pageCount,
          pageController: mockPageController,
        ),
      ),
    );
  }

  testWidgets('AboutCard displays correct title and description',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.card_title_1), findsOneWidget);
    expect(find.text(l10n.card_description_1), findsOneWidget);
  });

  testWidgets('AboutCard has a Scrollbar', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(Scrollbar), findsOneWidget);
  });

  testWidgets('AboutCard has a Divider', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('AboutCard has AboutCardArrows', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AboutCardArrows), findsOneWidget);
  });

  testWidgets('AboutCardArrows can navigate pages',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final aboutCardArrowsFinder = find.byType(AboutCardArrows);

    expect(aboutCardArrowsFinder, findsOneWidget);

    final aboutCardArrows = tester.widget<AboutCardArrows>(aboutCardArrowsFinder);

    aboutCardArrows.pageController.jumpToPage(1);
    await tester.pumpAndSettle();

    verify(() => mockPageController.jumpToPage(1)).called(1);
  });
}