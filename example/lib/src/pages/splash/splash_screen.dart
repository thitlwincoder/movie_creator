import 'package:example/services/localization/providers/localization_provider.dart';
import 'package:example/services/themes/helpers/dark_mode/dark_mode_helper.dart';
import 'package:example/services/themes/helpers/light_mode/light_mode_helper.dart';
import 'package:example/services/themes/providers/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeServiceProvider);
    final locale = ref.watch(appLocalizationServiceProvider);

    return MaterialApp(
      themeMode: themeMode,
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterLogo(size: 100),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('Movie Creator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
