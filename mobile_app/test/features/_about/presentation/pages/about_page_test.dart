import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_about/presentation/pages/about_page.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card.dart';
import 'package:mobile_app/features/_about/presentation/widgets/bottom_scroll_icons.dart';
import 'package:mobile_app/l10n/l10n.dart';

Widget createWidgetUnderTest() {
  return const MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: AboutPage(),
  );
}

void main() {
  testWidgets('AboutPage builds PageView and BottomScrollIcons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(BottomScrollIcons), findsOneWidget);
  });

  testWidgets('PageView changes pages correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final pageViewFinder = find.byType(PageView);

    await tester.drag(pageViewFinder, const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('AboutPage displays AboutCard widgets',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AboutCard), findsNWidgets(1));
  });

  testWidgets('BottomScrollIcons displays correct number of icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final bottomScrollIcons =
        tester.widget<BottomScrollIcons>(find.byType(BottomScrollIcons));
    expect(bottomScrollIcons.pageCount, 3);
  });
}
