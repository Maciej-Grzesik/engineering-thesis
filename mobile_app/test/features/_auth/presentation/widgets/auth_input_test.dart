import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/features/_auth/presentation/widgets/auth_input.dart';

void main() {
  late TextEditingController textEditingController;

  setUp(() {
    textEditingController = TextEditingController();
  });

  tearDown(() {
    textEditingController.dispose();
  });

  Widget createWidgetUnderTest({required String hintText, required bool isObscureText}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AuthInput(
          textEditingController: textEditingController,
          hintText: hintText,
          isObscureText: isObscureText,
        ),
      ),
    );
  }

  testWidgets('displays hint text correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(hintText: 'email', isObscureText: false));
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(find.text(l10n.email), findsOneWidget);
  });

  testWidgets('toggles password visibility when icon is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(hintText: 'password', isObscureText: true));

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    expect(find.byIcon(Icons.visibility_rounded), findsNothing);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off), findsNothing);
    expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
  });

  testWidgets('does not display password visibility icon for non-password fields', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(hintText: 'email', isObscureText: false));

    expect(find.byIcon(Icons.visibility_off), findsNothing);
    expect(find.byIcon(Icons.visibility_rounded), findsNothing);
  });

  testWidgets('autofill hints are set correctly for email field', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(hintText: 'email', isObscureText: false));

    final textField = tester.widget<TextField>(find.descendant(of: find.byType(TextFormField), matching: find.byType(TextField)));
    expect(textField.autofillHints, [AutofillHints.email]);
  });

  testWidgets('autofill hints are set correctly for password field', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(hintText: 'password', isObscureText: true));

    final textField = tester.widget<TextField>(find.descendant(of: find.byType(TextFormField), matching: find.byType(TextField)));
    expect(textField.autofillHints, [AutofillHints.password]);
  });
}