import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/common/models/language.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/localization_bloc/localization_bloc.dart';

void main() {
  group('AppLocalizationState', () {
    test('copyWith should override selectedLanguage when provided', () {
      const oldState = AppLocalizationState(selectedLanguage: Language.en);
      final newState = oldState.copyWith(selectedLanguage: Language.pl);
      expect(newState.selectedLanguage, Language.pl);
    });

    test('copyWith should retain current selectedLanguage if null is provided', () {
      const oldState = AppLocalizationState(selectedLanguage: Language.en);
      final newState = oldState.copyWith();
      expect(newState.selectedLanguage, Language.en);
    });
  });
}