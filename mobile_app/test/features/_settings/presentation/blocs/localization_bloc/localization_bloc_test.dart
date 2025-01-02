import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/localization_bloc/localization_bloc.dart';
import 'package:mobile_app/core/common/models/language.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocalizationBloc', () {
    late LocalizationBloc localizationBloc;

    setUp(() {
      localizationBloc = LocalizationBloc();
    });

    tearDown(() {
      localizationBloc.close();
    });

    blocTest<LocalizationBloc, AppLocalizationState>(
      'emits [AppLocalizationState] with updated language when ChangeLanguage is added',
      build: () => localizationBloc,
      act: (bloc) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        bloc.add(const ChangeLanguage(selectedLanguage: Language.en));
      },
      expect: () => [
        const AppLocalizationState(selectedLanguage: Language.en),
      ],
    );

    blocTest<LocalizationBloc, AppLocalizationState>(
      'emits [AppLocalizationState] with saved language when GetLanguage is added',
      build: () => localizationBloc,
      act: (bloc) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(languagePrefsKey, 'en');
        bloc.add(GetLanguage());
      },
      expect: () => [
        const AppLocalizationState(selectedLanguage: Language.en),
      ],
    );

    blocTest<LocalizationBloc, AppLocalizationState>(
      'emits [AppLocalizationState] with default language when no language is saved and GetLanguage is added',
      build: () => localizationBloc,
      act: (bloc) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        bloc.add(GetLanguage());
      },
      expect: () => [
        const AppLocalizationState(selectedLanguage: Language.en),
      ],
    );
  });
}