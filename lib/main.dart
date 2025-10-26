import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iptv_player/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iptv_player/common/constants/language_constants.dart';
import 'package:iptv_player/common/helpers/db_helper.dart';
import 'package:iptv_player/common/theme/app_theme.dart';
import 'package:iptv_player/common/widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  DBHelper db = DBHelper.instance;
  await db.initDB();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((Locale locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPTV Player',
      themeMode: ThemeMode.light,
      theme: themes[ThemeMode.light]!.themeData,
      darkTheme: themes[ThemeMode.dark]!.themeData,
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en'), // English
        const Locale('vi'), // Vietnamese
        const Locale('es'), // Spanish
        const Locale('fr'), // French (France)
        const Locale('hi'), // Hindi (India)
        const Locale('pt'), // Portuguese (Portugal/Brazil)
        const Locale('de'), // German (Germany)
        const Locale('zh'), // Chinese (Simplified)
        const Locale('ar'), // Arabic (Saudi Arabia)
      ],
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(),
    );
  }
}
