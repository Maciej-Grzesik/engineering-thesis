import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_app/core/theme/theme.dart';
import 'package:mobile_app/features/_auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app/features/_auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/localization_bloc/localization_bloc.dart';
import 'package:mobile_app/features/_settings/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:mobile_app/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:mobile_app/features/entry_point/presentation/bloc/entry_point_bloc.dart';
import 'package:mobile_app/features/navbar/presentation/bloc/navbar_bloc.dart';
import 'package:mobile_app/features/_user/presentation/bloc/user_bloc.dart';
import 'package:mobile_app/features/side_menu/presentation/bloc/side_menu_bloc.dart';
import 'package:mobile_app/init_dependencies.dart';
import 'package:mobile_app/l10n/l10n.dart';

import 'package:provider/provider.dart';

void main() async {
  await initDependencies();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<EntryPointBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<SideMenuBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<NavbarBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<CameraBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<UserBloc>(),
        ),
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
