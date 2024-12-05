import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/models/utils/styled_expansions_tile.dart';
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
          StyledExpansionTile(
            title:
                "${AppLocalizations.of(context)!.theme}: ${themeProvider.themeDataStyle == ThemeDataStyle.dark ? AppLocalizations.of(context)!.dark : AppLocalizations.of(context)!.light}",
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    themeProvider.themeDataStyle == ThemeDataStyle.dark
                        ? AppLocalizations.of(context)!.dark_theme
                        : AppLocalizations.of(context)!.light_theme,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.1,
                    child: Switch(
                        activeColor:
                            themeProvider.themeDataStyle.colorScheme.primary,
                        inactiveThumbColor:
                            themeProvider.themeDataStyle.colorScheme.primary,
                        trackOutlineColor: WidgetStateProperty.all(
                            themeProvider.themeDataStyle.colorScheme.outline),
                        trackColor: WidgetStateProperty.all(
                            themeProvider.themeDataStyle.colorScheme.surface),
                        value:
                            themeProvider.themeDataStyle == ThemeDataStyle.dark
                                ? true
                                : false,
                        onChanged: (isOn) {
                          themeProvider.changeTheme();
                        }),
                  ),
                ],
              )
            ],
          ),
          StyledExpansionTile(
            title: "${AppLocalizations.of(context)!.language}: ${localeProvider.locale!.languageCode == "en" ? AppLocalizations.of(context)!.english : AppLocalizations.of(context)!.polish}",
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          context.colorScheme.primaryContainer),
                    ),
                    onPressed: () =>
                        localeProvider.setLocale(const Locale('en')),
                    child: Text(
                      AppLocalizations.of(context)!.english,
                      style: TextStyle(
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          context.colorScheme.primaryContainer),
                    ),
                    onPressed: () =>
                        localeProvider.setLocale(const Locale('pl')),
                    child: Text(
                      AppLocalizations.of(context)!.polish,
                      style: TextStyle(
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
