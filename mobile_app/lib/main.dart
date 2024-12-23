import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_app/core/theme/theme.dart';
import 'package:mobile_app/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:mobile_app/features/theme/bloc/theme_bloc.dart';
import 'package:mobile_app/init_dependencies.dart';
import 'package:mobile_app/l10n/l10n.dart';
import 'package:provider/provider.dart';

void main() async {
  await initDependencies();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => LocalizationBloc()..add(GetLanguage()),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, AppLocalizationState>(
      buildWhen: (previous, current) =>
          previous.selectedLanguage != current.selectedLanguage,
      builder: (context, localizationState) {
        return BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Engineering thesis',
              theme: ThemeDataStyle.light,
              darkTheme: ThemeDataStyle.dark,
              themeMode: themeState,
              locale: localizationState.selectedLanguage.value,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const LoginPage(),
            );
          },
        );
      },
    );
  }
}
