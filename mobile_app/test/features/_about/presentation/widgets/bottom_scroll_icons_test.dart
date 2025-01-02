import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_about/presentation/widgets/bottom_scroll_icons.dart';

void main() {
  testWidgets('BottomScrollIcons displays correct number of icons',
      (WidgetTester tester) async {
    const currentPage = 0;
    const pageCount = 5;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body:
              BottomScrollIcons(currentPage: currentPage, pageCount: pageCount),
        ),
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(pageCount));
  });

  testWidgets('BottomScrollIcons highlights the current page icon',
      (WidgetTester tester) async {
    const currentPage = 2;
    const pageCount = 5;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body:
              BottomScrollIcons(currentPage: currentPage, pageCount: pageCount),
        ),
      ),
    );

    final animatedContainers = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();

    for (int i = 0; i < pageCount; i++) {
      final container = animatedContainers[i];
      if (i == currentPage) {
        expect(container.constraints?.maxWidth, 12);
        expect(
            container.decoration,
            BoxDecoration(
              color: Theme.of(tester.element(
                      find.byWidgetPredicate((widget) => widget == container)))
                  .colorScheme
                  .secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ));
      } else {
        expect(container.constraints?.maxWidth, 8);
        expect(
            container.decoration,
            BoxDecoration(
              color: Theme.of(tester.element(find.byWidget(container)))
                  .colorScheme
                  .onSecondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ));
      }
    }
  });

  testWidgets('BottomScrollIcons updates when currentPage changes',
      (WidgetTester tester) async {
    const pageCount = 5;
    int currentPage = 0;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: BottomScrollIcons(
                  currentPage: currentPage, pageCount: pageCount),
            ),
          );
        },
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(pageCount));

    currentPage = 3;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: BottomScrollIcons(
                  currentPage: currentPage, pageCount: pageCount),
            ),
          );
        },
      ),
    );

    final animatedContainers = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();

    for (int i = 0; i < pageCount; i++) {
      final container = animatedContainers[i];
      if (i == currentPage) {
        expect(container.constraints?.maxWidth, 12);
        expect(
            container.decoration,
            BoxDecoration(
              color: Theme.of(tester.element(find.byWidget(container)))
                  .colorScheme
                  .secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ));
      } else {
        expect(container.constraints?.maxWidth, 8);
        expect(
            container.decoration,
            BoxDecoration(
              color: Theme.of(tester.element(find.byWidget(container)))
                  .colorScheme
                  .onSecondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ));
      }
    }
  });
}
