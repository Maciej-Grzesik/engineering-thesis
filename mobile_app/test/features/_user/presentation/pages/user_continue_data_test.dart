import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_user/presentation/pages/user_continue_data.dart';

typedef Callback = void Function(MethodCall call);
void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: MissingUserDataWidget(),
      ),
    );
  }

  testWidgets('navigates back when Go back button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();

    expect(find.text('Go back'), findsNothing);
  });

  testWidgets('navigates to next page when second button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Continue'), findsOneWidget);
  });
}
