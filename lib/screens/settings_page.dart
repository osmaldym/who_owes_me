import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_owes_me/constants/brightness_mode.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';
import 'package:who_owes_me/main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    super.key,
    
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, String>> langs = [
    {
      'lang': 'en',
      'name': 'English'
    },
    {
      'lang': 'es',
      'name': 'Español'
    },
  ];

  int? _selectedBrightnessMode = 0;
  String? _selectedLang;


  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  void _updateSelectedBrightnessMode(BuildContext context) {
    final ThemeMode? themeMode = MainApp.of(context)?.getThemeMode();
    final ThemeMode theme = themeMode ?? ThemeMode.system;

    switch (theme) {
      case ThemeMode.light:
        _selectedBrightnessMode = BrightnessMode.light;
        break;

      case ThemeMode.dark:
        _selectedBrightnessMode = BrightnessMode.dark;
        break;

      default:
        _selectedBrightnessMode = BrightnessMode.system;
    }
  }

  @override
  void initState() {
    _selectedLang = langs[0]['lang'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateSelectedBrightnessMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Text(
              AppLocalizations.of(context)!.settings,
                style: const TextStyle(
                  fontSize: 24,
                ),
            ),
            Row(
              spacing: 10,
              children: [
                const Icon(Icons.brightness_4_outlined),
                Text(
                  AppLocalizations.of(context)!.mode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            RadioGroup<int>(
              groupValue: _selectedBrightnessMode,
              onChanged: (val) async {
                switch (val) {
                  case BrightnessMode.light:
                    await prefs.setInt('brightness', BrightnessMode.light);
                    if (context.mounted) MainApp.of(context)?.setThemeMode(ThemeMode.light);
                    break;

                  case BrightnessMode.dark:
                    await prefs.setInt('brightness', BrightnessMode.dark);
                    if (context.mounted) MainApp.of(context)?.setThemeMode(ThemeMode.dark);
                    break;
                  
                  default:
                    await prefs.setInt('brightness', BrightnessMode.system);
                    if (context.mounted) MainApp.of(context)?.setThemeMode(ThemeMode.system);
                }

                setState(() {
                  _selectedBrightnessMode = val;
                });
              },
              child: Column(
                spacing: 5,
                children: [
                  RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.light,
                    title: Text(AppLocalizations.of(context)!.light)
                  ),
                  RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.dark,
                    title: Text(AppLocalizations.of(context)!.dark)
                  ),
                  RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.system,
                    selected: true,
                    title: Text(AppLocalizations.of(context)!.system)
                  ),
                ],
              )
            ),
            Row(
              spacing: 10,
              children: [
                const Icon(Icons.language),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            DropdownButton<String>(
              isExpanded: true,
              items: langs.map((lang) => DropdownMenuItem(
                  value: lang['lang'],
                  child: Row(
                    spacing: 5,
                    children: [
                      Text(lang['name'] ?? AppLocalizations.of(context)!.unknown)
                    ],
                  ),
                )
              ).toList(),
              value: _selectedLang,
              onChanged: (lang) async {
                lang ??= 'en';

                prefs.setString('lang', lang);
                MainApp.of(context)?.setLocale(Locale(lang));
                setState(() => _selectedLang = lang);
              }
            )
          ],
        )
      )
    );
  }
}