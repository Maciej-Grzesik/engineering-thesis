import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/utils/locale_provider.dart';
import 'package:mobile_app/utils/theme_data_style.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                themeProvider.themeDataStyle == ThemeDataStyle.dark
                    ? 'Dark Theme'
                    : AppLocalizations.of(context)!.light_theme,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Transform.scale(
              scale: 1.4,
              child: Switch(
                activeColor: themeProvider.themeDataStyle.colorScheme.primary,
                inactiveThumbColor: themeProvider.themeDataStyle.colorScheme.primary,
                trackOutlineColor: WidgetStateProperty.all(themeProvider.themeDataStyle.colorScheme.outline),
                trackColor: WidgetStateProperty.all(themeProvider.themeDataStyle.colorScheme.surface),
                  value: themeProvider.themeDataStyle == ThemeDataStyle.dark
                      ? true
                      : false,
                  onChanged: (isOn) {
                    debugPrint(
                        'Primary color: ${Theme.of(context).colorScheme.primary}');
                    debugPrint(
                        'OnSurface color: ${Theme.of(context).colorScheme.onSurface}');
                    themeProvider.changeTheme();
                  }
                ),
            ),
            ExpansionTile(title: const Text("Languages"),
              children: [
                ElevatedButton(
              onPressed: () => localeProvider.setLocale(const Locale('en')),
              child: const Text('Switch to English'),
            ),
            ElevatedButton(
              onPressed: () => localeProvider.setLocale(const Locale('pl')),
              child: const Text('Przełącz na Polski'),
            )
              ],
            )
          ],
        ),
    );
  }
} 