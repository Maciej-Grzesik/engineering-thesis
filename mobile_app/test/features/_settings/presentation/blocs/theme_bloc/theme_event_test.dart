import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/theme_bloc/theme_bloc.dart';

void main() {
  group('ThemeEvent tests', () {
    test('ChangeTheme is a subclass of ThemeEvent and Equatable', () {
      const event = ChangeTheme(true);
      expect(event, isA<ThemeEvent>());
      expect(event, isA<Equatable>());
    });

    test('Two ChangeTheme events with same isDark should be equal', () {
      const event1 = ChangeTheme(true);
      const event2 = ChangeTheme(true);
      expect(event1, equals(event2));
    });

    test('Two ChangeTheme events with different isDark should not be equal',
        () {
      const event1 = ChangeTheme(true);
      const event2 = ChangeTheme(false);
      expect(event1, isNot(equals(event2)));
    });

    test('props should return isDark in the list', () {
      const event = ChangeTheme(true);
      expect(event.props, [true]);
    });
  });
}
