import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_home_page/presentation/pages/home_page.dart';
import 'package:mobile_app/features/_user/presentation/pages/fill_user_data.dart';

void main() {
  Widget createWidgetUnderTest() {

    return const MaterialApp(
      home: Scaffold(
        body: UpdateUserDataPage(),
      ),
    );
  }


  /// there are problems in mocking the firebase dependencies
  testWidgets('displays Continue button with icon', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Continue'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_circle_right_outlined), findsOneWidget);
  });

  /// there are problems in mocking the firebase dependencies
  testWidgets('navigates to next page when Continue button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

  
    expect(find.byType(HomePage), findsOneWidget);
  });
}