// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iptv_player/l10n/app_localizations.dart';

const String LANGUAGE = 'languageCode';
const String ONBOARDING_COMPLETED = 'onboardingCompleted';

//languages code
const String ENGLISH = 'en';
const String VIETNAMESE = 'vi';
const String SPANISH = 'es';
const String FRENCH = 'fr';
const String PORTUGUESE = 'pt';
const String GERMAN = 'de';
const String CHINESE = 'zh';
const String FARSI = 'fa';
const String ARABIC = 'ar';
const String HINDI = 'hi';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(LANGUAGE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String languageCode = pref.getString(LANGUAGE) ?? ENGLISH;
  return _locale(languageCode);
}

Future<bool> isLocaleExists() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.containsKey(LANGUAGE);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case FARSI:
      return const Locale(FARSI, "");
    case ARABIC:
      return const Locale(ARABIC, "");
    case HINDI:
      return const Locale(HINDI, "");
    case VIETNAMESE:
      return const Locale(VIETNAMESE, '');
    case SPANISH:
      return const Locale(SPANISH, '');
    case FRENCH:
      return const Locale(FRENCH, '');
    case PORTUGUESE:
      return const Locale(PORTUGUESE, '');
    case GERMAN:
      return const Locale(GERMAN, '');
    case CHINESE:
      return const Locale(CHINESE, '');
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}

// Onboarding helpers
Future<bool> isOnboardingCompleted() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(ONBOARDING_COMPLETED) ?? false;
}

Future<void> setOnboardingCompleted() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setBool(ONBOARDING_COMPLETED, true);
}
