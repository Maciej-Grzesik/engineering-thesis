import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/_auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (_) => mockAuthBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Witaj ponownie!'), findsOneWidget);
    expect(find.text('Witamy z powrotem, tęskniliśmy za tobą!'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginPage calls AuthLogin on button press', (WidgetTester tester) async {
    when(() => mockAuthBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => mockAuthBloc.add(AuthLogin(email: 'test@example.com', password: 'password'))).called(1);
  });
}