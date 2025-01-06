import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/features/_about/presentation/widgets/about_card_arrows.dart';

class FakeDuration extends Fake implements Duration {}
class FakeCurve extends Fake implements Curve {}

class MockPageController extends Mock implements PageController {}

void main() {
  const padding = 16.0;
  const pageCount = 3;
  late MockPageController mockPageController;

  setUpAll(() {
    registerFallbackValue(FakeDuration());
    registerFallbackValue(FakeCurve());
  });

  setUp(() {
    mockPageController = MockPageController();

    when(() => mockPageController.nextPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        )).thenAnswer((_) async {});

    when(() => mockPageController.previousPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        )).thenAnswer((_) async {});
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
    await tester.pumpWidget(createWidgetUnderTest(0));
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

  testWidgets('tapping forward arrow calls pageController.nextPage',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(0));
    expect(find.byIcon(Icons.arrow_forward_sharp), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward_sharp));
    await tester.pumpAndSettle();

    verify(() => mockPageController.nextPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        )).called(1);
  });

  testWidgets('tapping back arrow calls pageController.previousPage',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(1));
    expect(find.byIcon(Icons.arrow_back_sharp), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_sharp));
    await tester.pumpAndSettle();

    verify(() => mockPageController.previousPage(
          duration: any(named: 'duration'),
          curve: any(named: 'curve'),
        )).called(1);
  });
}