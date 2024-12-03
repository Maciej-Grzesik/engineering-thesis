import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:mobile_app/pages/entry_point.dart';
import 'package:mobile_app/pages_finished/login_page.dart';
import 'package:mobile_app/pages/register_page.dart';
import 'package:mobile_app/utils/locale_provider.dart';
import 'package:mobile_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello :3',
      darkTheme: Provider.of<ThemeProvider>(context).themeDataStyle,
      // home: const WelcomePage(
      //   title: 'Home',
      // ),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const LoginPage(),
      locale: locale,
    );
  }
}
