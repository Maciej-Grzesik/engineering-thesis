import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';

void main() {
  group('NavbarEvent', () {
    test('SendClassificationEvent supports value comparisons', () {
      expect(SendClassificationEvent(), SendClassificationEvent());
    });

    test('GoBack supports value comparisons', () {
      expect(GoBack(), GoBack());
    });

    test('PushPage supports value comparisons', () {
      final page = Container();
      expect(PushPage(page), PushPage(page));
    });

    test('PushPage props are correct', () {
      final page = Container();
      expect(PushPage(page).props, [page]);
    });

    test('SendClassificationEvent props are correct', () {
      expect(SendClassificationEvent().props, []);
    });

    test('GoBack props are correct', () {
      expect(GoBack().props, []);
    });
  });
}