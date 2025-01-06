import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';

void main() {
  group('SideMenuBloc', () {
    late SideMenuBloc sideMenuBloc;

    setUp(() {
      sideMenuBloc = SideMenuBloc();
    });

    tearDown(() {
      sideMenuBloc.close();
    });

    test('initial state is SideMenuCollapsed', () {
      expect(sideMenuBloc.state, SideMenuCollapsed());
    });

    blocTest<SideMenuBloc, SideMenuState>(
      'emits [SideMenuExtended] when OnMenuToggle is added and current state is SideMenuCollapsed',
      build: () => sideMenuBloc,
      act: (bloc) => bloc.add(OnMenuToggle()),
      expect: () => [SideMenuExtended()],
    );

    blocTest<SideMenuBloc, SideMenuState>(
      'emits [SideMenuCollapsed] when OnMenuToggle is added and current state is SideMenuExtended',
      build: () => sideMenuBloc,
      seed: () => SideMenuExtended(),
      act: (bloc) => bloc.add(OnMenuToggle()),
      expect: () => [SideMenuCollapsed()],
    );
  });
}