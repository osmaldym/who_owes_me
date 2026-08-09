import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_owes_me/constants/brightness_mode.dart';
import 'package:who_owes_me/router/router.dart';
import 'package:who_owes_me/widgets/main_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
  final Color appSeedColor = const Color(0xFFFFE32E);

  MyApp({super.key});

  Future<void> _loadPrefs() async {
    int? brightnessMode = await prefs.getInt('brightness');
    
    switch (brightnessMode) {
      case BrightnessMode.light:
        themeNotifier.value = ThemeMode.light;
      case BrightnessMode.dark:
        themeNotifier.value = ThemeMode.dark;
      default:
        themeNotifier.value = ThemeMode.system;
    }
  }

  @override
  StatelessElement createElement() {
    _loadPrefs();
    return super.createElement();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainProvider(
      notifier: themeNotifier,
      child: ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_, brightnessMode, __) => MaterialApp.router(
          routerConfig: router,
          title: 'Who Owes Me',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: appSeedColor),
            filledButtonTheme: FilledButtonThemeData(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: appSeedColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: brightnessMode,
        )
      )
    );
  }
}
