import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeBloc', () {
    late ThemeBloc themeBloc;

    setUp(() {
      themeBloc = ThemeBloc();
    });

    tearDown(() {
      themeBloc.close();
    });

    blocTest<ThemeBloc, ThemeMode>(
      'emits [ThemeMode.dark] when ChangeTheme with isDark true is added',
      build: () => themeBloc,
      act: (bloc) => bloc.add(const ChangeTheme(true)),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeBloc, ThemeMode>(
      'emits [ThemeMode.light] when ChangeTheme with isDark false is added',
      build: () => themeBloc,
      act: (bloc) => bloc.add(const ChangeTheme(false)),
      expect: () => [ThemeMode.light],
    );
  });
}