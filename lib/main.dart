import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_owes_me/constants/brightness_mode.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
import 'package:who_owes_me/router/router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => MainAppState();

  static MainAppState? of(BuildContext context) => context.findAncestorStateOfType<MainAppState>();
}

class MainAppState extends State<MainApp> {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  final Color appSeedColor = const Color(0xFFFFE32E);
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  Future<void> loadPrefs() async {
    int? brightnessMode = await prefs.getInt('brightness');

    setState(() {
      switch (brightnessMode) {
        case BrightnessMode.light:
          _themeMode = ThemeMode.light;
        case BrightnessMode.dark:
          _themeMode = ThemeMode.dark;
        default:
          _themeMode = ThemeMode.system;
      }  
    });
  }

  void setThemeMode(ThemeMode themeMode) => setState(() => _themeMode = themeMode);
  ThemeMode getThemeMode() => _themeMode;

  void setLocale(Locale locale) => setState(() => _locale = locale);

  @override
  void initState() {
    loadPrefs();
    return super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
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
      themeMode: _themeMode,
    );
  }
}
