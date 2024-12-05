import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/theme_data_style.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeDataStyle;

  ThemeProvider() : _themeDataStyle = _getSystemTheme();

  ThemeData get themeDataStyle => _themeDataStyle;

  set themeDataStyle(ThemeData themeData) {
    _themeDataStyle = themeData;
    notifyListeners();
  }

  static ThemeData _getSystemTheme() {
    final Brightness brightness =
        PlatformDispatcher.instance.platformBrightness;
    if (brightness == Brightness.dark) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
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


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ThemeProvider extends ChangeNotifier {
//   ThemeData _themeDataStyle;

//   ThemeProvider() : _themeDataStyle = _getSystemTheme();

//   ThemeData get themeDataStyle => _themeDataStyle;

//   set themeDataStyle(ThemeData themeData) {
//     _themeDataStyle = themeData;
//     notifyListeners();
//   }

//   static ThemeData _getSystemTheme() {
//     final Brightness brightness =
//         PlatformDispatcher.instance.platformBrightness;
//     if (brightness == Brightness.dark) {
//       return ThemeData.dark();
//     } else {
//       return ThemeData.light();
//     }
//   }

//   void changeTheme() {
//     if (_themeDataStyle.brightness == Brightness.light) {
//       themeDataStyle = ThemeData.dark();
//     } else {
//       themeDataStyle = ThemeData.light();
//     }
//   }
// }

// extension ThemeExtensions on BuildContext {
//   ColorScheme get colorScheme => Provider.of<ThemeProvider>(this, listen: false)
//       .themeDataStyle
//       .colorScheme;
// }
