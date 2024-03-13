import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/services/app_preference/models/app_preference.dart';
import '/services/local_storage/isar/constants/isar_constants.dart';
import '/services/local_storage/isar/providers/isar_provider.dart';
import '/services/riverpod/riverpod.dart';

part 'app_settings_provider.g.dart';

@riverpod
class AppSettings extends _$AppSettings {
  @override
  Future<AppPreferences> build() async {
    ProviderHelper.onInit('AppSettings', ref.formatHash);
    return _getData();
  }

  void updateLanguage(String language) {
    final appPreferences = state.value;
    appPreferences?.language = language;
    _update(appPreferences);
  }

  void updateIsSystemThemeMode(ThemeMode themeMode) {
    final appPreferences = state.value;
    appPreferences?.themeMode = themeMode;
    _update(appPreferences);
  }

  void reset() {
    final appPreferences = AppPreferences();
    _update(appPreferences);
  }

  void _update(AppPreferences? appPreferences) {
    if (appPreferences != null) {
      _savePreferences(appPreferences);
      state = AsyncValue.data(appPreferences);
    }
  }

  Future<AppPreferences> _getData() async {
    final isar = await ref.read(isarServiceProvider.future);
    final appPreferences =
        await isar?.appPreferences.get(IsarConstantsCollections.appPreferences);

    await Future.delayed(const Duration(milliseconds: 700));

    if (appPreferences != null) {
      return appPreferences;
    }

    final newAppPreferences = AppPreferences();
    _savePreferences(newAppPreferences);
    return newAppPreferences;
  }

  Future<void> _savePreferences(AppPreferences preferences) async {
    final isar = await ref.read(isarServiceProvider.future);
    await isar?.writeTxn(() async => isar.appPreferences.put(preferences));
  }
}
