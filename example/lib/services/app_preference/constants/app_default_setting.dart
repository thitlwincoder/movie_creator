import 'package:flutter/material.dart';

import '/services/localization/providers/localization_provider.dart';

@immutable
class AppDefaultSettings {
  static ThemeMode get themeMode => _themeMode;
  static Locale get locale => _locale;

  static const _themeMode = ThemeMode.system;
  static const _locale = AppLocales.enUS;
}
