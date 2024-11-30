import 'package:flutter/material.dart';
import 'package:mobile_app/utils/theme_data_style.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeDataStyle = ThemeDataStyle.light;

  ThemeData get themeDataStyle => _themeDataStyle;

  set themeDataStyle(ThemeData themeData) {
    _themeDataStyle = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeDataStyle == ThemeDataStyle.light) {
      themeDataStyle = ThemeDataStyle.dark;
    } else {
      themeDataStyle = ThemeDataStyle.light;
    }
  }
}

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Provider.of<ThemeProvider>(this, listen: false).themeDataStyle.colorScheme;
}
