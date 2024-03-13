import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/services/app_preference/providers/app_settings_provider.dart';

part 'theme_mode_provider.g.dart';

@riverpod
ThemeMode? appThemeService(AppThemeServiceRef ref) {
  final appSettings = ref.watch(appSettingsProvider);

  final k = appSettings.whenData((v) => v.themeMode);

  return k.value;
}
