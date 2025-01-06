import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockNavbarBloc extends MockBloc<NavbarEvent, NavbarState> implements NavbarBloc {}

class FakeWidget extends StatelessWidget {
  const FakeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  late MockNavbarBloc mockNavbarBloc;

  setUpAll(() {
    registerFallbackValue(const FakeWidget());
  });

  setUp(() {
    mockNavbarBloc = MockNavbarBloc();
  });

  tearDown(() {
    mockNavbarBloc.close();
  });

  group('NavbarBloc', () {
    test('initial state is NavbarInitial', () {
      expect(mockNavbarBloc.state, NavbarInitial());
    });

    blocTest<NavbarBloc, NavbarState>(
      'emits [NavbarLoading, PushPageSuccess] when PushPage is added',
      build: () => NavbarBloc(),
      act: (bloc) => bloc.add(const PushPage(FakeWidget())),
      expect: () => [
        NavbarLoading(),
        isA<PushPageSuccess>(),
      ],
    );

    blocTest<NavbarBloc, NavbarState>(
      'emits [NavbarLoading, GoBackSuccess] when GoBack is added and page stack has more than one page',
      build: () => NavbarBloc()..add(const PushPage(FakeWidget()))..add(const PushPage(FakeWidget())),
      act: (bloc) => bloc.add(GoBack()),
      expect: () => [
        NavbarLoading(),
        isA<PushPageSuccess>(),
        NavbarLoading(),
        isA<PushPageSuccess>(),
        NavbarLoading(),
        isA<GoBackSuccess>(),
      ],
    );

    blocTest<NavbarBloc, NavbarState>(
      'emits [NavbarLoading, GoBackFailure] when GoBack is added and page stack has only one page',
      build: () => NavbarBloc()..add(const PushPage(FakeWidget())),
      act: (bloc) => bloc.add(GoBack()),
      expect: () => [
        NavbarLoading(),
        isA<PushPageSuccess>(),
        NavbarLoading(),
        isA<GoBackFailure>(),
      ],
    );

    blocTest<NavbarBloc, NavbarState>(
      'emits [NavbarSuccess] when SendClassificationEvent is added',
      build: () => NavbarBloc(),
      act: (bloc) => bloc.add(SendClassificationEvent()),
      expect: () => [
        NavbarSuccess(),
      ],
    );
  });
}