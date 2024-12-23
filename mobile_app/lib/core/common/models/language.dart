import 'dart:ui';

enum Language {
  pl(
    Locale('pl'),
    'Polski',
  ),
  en(
    Locale('en'),
    'English',
  );

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
