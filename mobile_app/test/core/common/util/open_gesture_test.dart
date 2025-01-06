import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/common/util/open_menu_gesture.dart';

void main() {
  group('OpenMenuGestureDetector', () {
    late Function mockOnOpenMenu;
    late Function mockOnCloseMenu;

    setUp(() {
      mockOnOpenMenu = () {};
      mockOnCloseMenu = () {};
    });

    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OpenMenuGestureDetector(
            onOpenMenu: mockOnOpenMenu,
            onCloseMenu: mockOnCloseMenu,
            child: const Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('calls onOpenMenu when swiping right in left edge area',
        (WidgetTester tester) async {
      bool menuOpened = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: OpenMenuGestureDetector(
            onOpenMenu: () => menuOpened = true,
            onCloseMenu: mockOnCloseMenu,
            child: Container(width: 400, height: 800, color: Colors.white),
          ),
        ),
      ));

      final TestPointer testPointer = TestPointer(1, PointerDeviceKind.touch);

      testPointer.down(const Offset(20, 400));
      await tester.pump(const Duration(milliseconds: 1));

      testPointer.move(const Offset(420, 400),
          timeStamp: const Duration(milliseconds: 5));
      await tester.pump(const Duration(milliseconds: 1));

      testPointer.up();
      await tester.pumpAndSettle();

      expect(menuOpened, isTrue);
    });

    testWidgets('calls onCloseMenu when swiping left in left edge area',
        (WidgetTester tester) async {
      bool menuClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: OpenMenuGestureDetector(
            onOpenMenu: mockOnOpenMenu,
            onCloseMenu: () => menuClosed = true,
            child: const SizedBox(width: 400, height: 800),
          ),
        ),
      );

      await tester.dragFrom(const Offset(20, 400), const Offset(-50, 400));
      await tester.pumpAndSettle();

      expect(menuClosed, isTrue);
    });

    testWidgets('does not trigger menu actions when swiping outside left edge',
        (WidgetTester tester) async {
      bool menuOpened = false;
      bool menuClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: OpenMenuGestureDetector(
            onOpenMenu: () => menuOpened = true,
            onCloseMenu: () => menuClosed = true,
            child: const SizedBox(width: 400, height: 800),
          ),
        ),
      );

      await tester.dragFrom(const Offset(150, 400), const Offset(300, 400));
      await tester.pumpAndSettle();

      expect(menuOpened, isFalse);
      expect(menuClosed, isFalse);
    });
  });
}
