import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'dark_mode_helper.g.dart';

@riverpod
ThemeData darkTheme(DarkThemeRef ref) {
  return ThemeData.dark(useMaterial3: true)
      .copyWith(colorScheme: ColorScheme.dark());
}
