import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '/services/app_preference/constants/app_default_setting.dart';
import '/services/local_storage/isar/constants/isar_constants.dart';
import '/services/themes/extention/color_extention.dart';

part 'app_preference.g.dart';

@collection
class AppPreferences {
  Id id = IsarConstantsCollections.appPreferences;

  String language = AppDefaultSettings.locale.toLanguageTag();
  @enumerated
  ThemeMode themeMode = AppDefaultSettings.themeMode;
}
