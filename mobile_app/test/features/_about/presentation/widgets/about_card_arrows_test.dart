import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card_arrows.dart';
import 'package:mocktail/mocktail.dart';

class MockPageController extends Mock implements PageController {}

void main() {
  const padding = 16.0;
  const currentPage = 0;
  const pageCount = 3;

  late MockPageController mockPageController;

  setUp(() {
    mockPageController = MockPageController();
  });

  Widget createWidgetUnderTest(int currentPage) {
    return MaterialApp(
      home: Scaffold(
        body: AboutCardArrows(
          padding: padding,
          currentPage: currentPage,
          pageController: mockPageController,
          pageCount: pageCount,
        ),
      ),
    );
  }

  testWidgets('AboutCardArrows displays forward arrow when not on last page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currentPage));

    expect(find.byIcon(Icons.arrow_forward_sharp), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_sharp), findsNothing);
  });

  testWidgets('AboutCardArrows displays back arrow when not on first page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(1));

    expect(find.byIcon(Icons.arrow_forward_sharp), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_sharp), findsOneWidget);
  });

  testWidgets('AboutCardArrows does not display forward arrow on last page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(pageCount - 1));

    expect(find.byIcon(Icons.arrow_forward_sharp), findsNothing);
    expect(find.byIcon(Icons.arrow_back_sharp), findsOneWidget);
  });
}