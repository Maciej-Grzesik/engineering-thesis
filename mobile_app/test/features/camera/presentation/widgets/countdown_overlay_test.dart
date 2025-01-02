import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/camera/presentation/widgets/countdown_overlay.dart';

void main() {
  testWidgets(
      'CountdownOverlay displays countdown and calls onCountdownComplete',
      (WidgetTester tester) async {
    bool countdownCompleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            CountdownOverlay(
              onCountdownComplete: () {
                countdownCompleteCalled = true;
              },
            ),
          ],
        ),
      ),
    );

    expect(find.text('Recording in 3...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Recording in 2...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Recording in 1...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Recording'), findsOneWidget);

    expect(countdownCompleteCalled, isTrue);
  });
}
