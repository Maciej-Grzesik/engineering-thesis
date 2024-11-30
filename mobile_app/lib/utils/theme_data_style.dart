import 'package:flutter/material.dart';

class ThemeDataStyle {
  static ThemeData light = ThemeData(
    colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF68548E),
    primaryContainer: Color(0xFFEBDDFF),
    secondary: Color(0xFF635B70),
    secondaryContainer: Color(0xFFE9DEF8),
    tertiary: Color(0xFF7E525D),
    tertiaryContainer: Color(0xFFFFD9E1),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    background: Color(0xFFFEFEF7),
    surface: Color(0xFFFEFEF7),
    surfaceContainerHighest: Color(0xFFE7E0E8),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF230F46),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFF1F182B),
    onTertiary: Color(0xFFFFFFFF),
    onTertiaryContainer: Color(0xFF31101B),
    onSurface: Color(0xFF1D1B20),
    onSurfaceVariant: Color(0xFF49454E),
    onError: Color(0xFFFFFFFF), 
    onErrorContainer: Color(0xFF410002),
    onInverseSurface: Color(0xFFF5EFF7),
    inversePrimary: Color(0xFFD3BCFD),
    inverseSurface: Color(0xFF322F35),
    outline: Color(0xFF7A757F), 
    outlineVariant: Color(0xFFCBC4CF),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF68548E),
    ),
  );

  static ThemeData dark = ThemeData(
    colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD3BCFD),
    primaryContainer: Color(0xFF4F3D74), 
    secondary: Color(0xFFCDC2DB), 
    secondaryContainer: Color(0xFF4B4358),
    tertiary: Color(0xFFF0B7C5),
    tertiaryContainer: Color(0xFF643B46),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    background: Color(0xFF151218),
    surface: Color(0xFF151218), 
    surfaceContainerHighest: Color(0xFF36343A),
    onPrimary: Color(0xFF38265C),
    onPrimaryContainer: Color(0xFFEBDDFF),
    onSecondary: Color(0xFF342D40),
    onSecondaryContainer: Color(0xFFE9DEF8),
    onTertiary: Color(0xFF4A2530),
    onTertiaryContainer: Color(0xFFFFD9E1),
    onSurface: Color(0xFFE7E0E8),
    onSurfaceVariant: Color(0xFFCBC4CF),
    onError: Color(0xFF690005), 
    onErrorContainer: Color(0xFFFFDAD6),
    onInverseSurface: Color(0xFF322F35),
    inversePrimary: Color(0xFF68548E),
    inverseSurface: Color(0xFFE7E0E8),
    outline: Color(0xFF948F99),
    outlineVariant: Color(0xFF49454E),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFD3BCFD),
    ),
  );
}