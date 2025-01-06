import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';

void main() {
  group('NavbarState', () {
    test('NavbarInitial supports value comparisons', () {
      expect(NavbarInitial(), NavbarInitial());
    });

    test('NavbarLoading supports value comparisons', () {
      expect(NavbarLoading(), NavbarLoading());
    });

    test('NavbarSuccess supports value comparisons', () {
      expect(NavbarSuccess(), NavbarSuccess());
    });

    test('NavbarFailure supports value comparisons', () {
      expect(const NavbarFailure('error'), const NavbarFailure('error'));
    });

    test('PushPageSuccess supports value comparisons', () {
      final pageStack = [Container(), Container()];
      expect(PushPageSuccess(pageStack), PushPageSuccess(pageStack));
    });

    test('GoBackSuccess supports value comparisons', () {
      final pageStack = [Container(), Container()];
      expect(GoBackSuccess(pageStack), GoBackSuccess(pageStack));
    });

    test('GoBackFailure supports value comparisons', () {
      final pageStack = [Container()];
      expect(GoBackFailure(pageStack, 'error'), GoBackFailure(pageStack, 'error'));
    });

    test('PageChanged supports value comparisons', () {
      final page = Container();
      expect(PageChanged(page), PageChanged(page));
    });

    test('NavbarFailure props are correct', () {
      expect(const NavbarFailure('error').props, ['error']);
    });

    test('PushPageSuccess props are correct', () {
      final pageStack = [Container(), Container()];
      expect(PushPageSuccess(pageStack).props, [pageStack]);
    });

    test('GoBackSuccess props are correct', () {
      final pageStack = [Container(), Container()];
      expect(GoBackSuccess(pageStack).props, [pageStack]);
    });

    test('GoBackFailure props are correct', () {
      final pageStack = [Container()];
      expect(GoBackFailure(pageStack, 'error').props, [pageStack]);
    });

    test('PageChanged props are correct', () {
      final page = Container();
      expect(PageChanged(page).props, [page]);
    });
  });
}