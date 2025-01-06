import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/entry_point/presentation/widgets/menu_button.dart';

void main() {
  late bool isMenuOpen;
  late VoidCallback press;

  setUp(() {
    isMenuOpen = false;
    press = () {
      isMenuOpen = !isMenuOpen;
    };
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: MenuButton(
          isMenuOpen: isMenuOpen,
          press: press,
        ),
      ),
    );
  }

  testWidgets('initial state of MenuButton when isMenuOpen is false', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.close_outlined), findsNothing);
  });

  testWidgets('state of MenuButton when isMenuOpen is true', (WidgetTester tester) async {
    isMenuOpen = true;
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.menu), findsNothing);
    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
  });

  testWidgets('MenuButton tap changes state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.close_outlined), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.menu), findsNothing);
    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
  });
}