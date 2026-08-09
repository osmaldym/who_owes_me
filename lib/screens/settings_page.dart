import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_owes_me/constants/brightness_mode.dart';
import 'package:who_owes_me/widgets/main_provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    super.key,
    
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? _selectedBrightnessMode = 0;

  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  ValueNotifier<ThemeMode>? _updateAndGetSelectedBrightnessMode(BuildContext context) {
    final ValueNotifier<ThemeMode>? notifier = MainProvider.of(context)?.notifier;
    final ThemeMode theme = notifier != null ? notifier.value : ThemeMode.system;

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

    return notifier;
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<ThemeMode>? theme = _updateAndGetSelectedBrightnessMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            const Text(
              'Settings',
                style: TextStyle(
                  fontSize: 24,
                ),
            ),
            const Row(
              spacing: 10,
              children: [
                Icon(Icons.brightness_4_outlined),
                Text(
                  'Mode',
                  style: TextStyle(
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
                    theme?.value = ThemeMode.light;
                    break;

                  case BrightnessMode.dark:
                    await prefs.setInt('brightness', BrightnessMode.dark);
                    theme?.value = ThemeMode.dark;
                    break;
                  
                  default:
                    await prefs.setInt('brightness', BrightnessMode.system);
                    theme?.value = ThemeMode.system;
                }

                setState(() {
                  _selectedBrightnessMode = val;
                });
              },
              child: const Column(
                spacing: 5,
                children: [
                  RadioListTile(
                    contentPadding: EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.light,
                    title: Text('Light')
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.dark,
                    title: Text('Dark')
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    value: BrightnessMode.system,
                    selected: true,
                    title: Text('System')
                  ),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}