import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/localization_bloc/localization_bloc.dart';
import 'package:mobile_app/core/common/models/language.dart';

void main() {
  group('ChangeLanguage tests', () {
    test('is a subclass of LocalizationEvent and Equatable', () {
      const event = ChangeLanguage(selectedLanguage: Language.pl);
      expect(event, isA<LocalizationEvent>());
      expect(event, isA<Equatable>());
    });

    test('props returns [selectedLanguage]', () {
      const event = ChangeLanguage(selectedLanguage: Language.pl);
      expect(event.props, [Language.pl]);
    });

    test('two events with same Language are equal', () {
      const event1 = ChangeLanguage(selectedLanguage: Language.en);
      const event2 = ChangeLanguage(selectedLanguage: Language.en);
      expect(event1, equals(event2));
    });

    test('two events with different Language are not equal', () {
      const event1 = ChangeLanguage(selectedLanguage: Language.en);
      const event2 = ChangeLanguage(selectedLanguage: Language.pl);
      expect(event1, isNot(equals(event2)));
    });
  });

  group('GetLanguage tests', () {
    test('is a subclass of LocalizationEvent and Equatable', () {
      final event = GetLanguage();
      expect(event, isA<LocalizationEvent>());
      expect(event, isA<Equatable>());
    });

    test('props returns an empty list', () {
      final event = GetLanguage();
      expect(event.props, isEmpty);
    });

    test('two GetLanguage events are equal', () {
      final event1 = GetLanguage();
      final event2 = GetLanguage();
      expect(event1, equals(event2));
    });
  });
}