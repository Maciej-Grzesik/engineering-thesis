import 'dart:ui';

import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  _loadLocale() async {
    final deviceLocale = await _getDeviceLocale();
    _locale = deviceLocale;
    notifyListeners();
  }

  Future<Locale> _getDeviceLocale() async {
    final systemLocale = await _getSystemLocale();
    return systemLocale;
  }

  Future<Locale> _getSystemLocale() async {
    final locale = await _getLocaleFromSystem();
    return locale;
  }

  Future<Locale> _getLocaleFromSystem() async {
    final systemLocale = PlatformDispatcher.instance.locales.first;
    return systemLocale;
  }

  void setLocale(Locale locale) {
    if (!['en', 'pl'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners(); 
  }
}
