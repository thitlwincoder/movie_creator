import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'light_mode_helper.g.dart';

@riverpod
ThemeData lightTheme(LightThemeRef ref) {
  return ThemeData.light(useMaterial3: true)
      .copyWith(colorScheme: ColorScheme.light());
}
