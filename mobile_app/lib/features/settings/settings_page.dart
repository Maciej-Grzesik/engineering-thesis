import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/.rewriting/models/utils/styled_expansions_tile.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mobile_app/core/common/models/language.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:mobile_app/features/theme/bloc/theme_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledExpansionTile(
            title:
                "${AppLocalizations.of(context)!.theme}: ${context.read<ThemeBloc>().state == ThemeMode.dark ? AppLocalizations.of(context)!.dark : AppLocalizations.of(context)!.light}",
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.read<ThemeBloc>().state == ThemeMode.dark
                        ? AppLocalizations.of(context)!.dark_theme
                        : AppLocalizations.of(context)!.light_theme,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.1,
                    child: Switch(
                        activeColor: colorScheme.primary,
                        inactiveThumbColor: colorScheme.primary,
                        trackOutlineColor:
                            WidgetStateProperty.all(colorScheme.outline),
                        trackColor:
                            WidgetStateProperty.all(colorScheme.surface),
                        value:
                            context.read<ThemeBloc>().state == ThemeMode.dark,
                        onChanged: (isOn) {
                          context.read<ThemeBloc>().add(
                                ChangeTheme(isOn),
                              );
                        }),
                  ),
                ],
              )
            ],
          ),
          StyledExpansionTile(
            title: l10n.language,
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(colorScheme.primaryContainer),
                    ),
                    onPressed: () => {
                      context.read<LocalizationBloc>().add(
                            const ChangeLanguage(
                              selectedLanguage: Language.en,
                            ),
                          ),
                    },
                    child: Text(
                      AppLocalizations.of(context)!.english,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(colorScheme.primaryContainer),
                    ),
                    onPressed: () => {
                      context.read<LocalizationBloc>().add(
                            const ChangeLanguage(
                              selectedLanguage: Language.pl,
                            ),
                          ),
                    },
                    child: Text(
                      AppLocalizations.of(context)!.polish,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
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
