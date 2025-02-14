import 'package:flutter/material.dart';
import 'package:iptv_player/common/theme/font_family.dart';
import 'package:iptv_player/common/theme/palette.dart';

final Map<ThemeMode, ThemeSheet> themes = {
  ThemeMode.light: ThemeSheet(palette: Palette.light()),
  ThemeMode.dark: ThemeSheet(palette: Palette.dark()),
};

class ThemeSheet {
  final ThemeData themeData;
  final Palette palette;

  ThemeSheet({required this.palette})
      : themeData = ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          brightness: palette.brightness,
          fontFamily: FontFamily.mulish,
          scaffoldBackgroundColor: palette.scaffoldBackground,
          colorScheme: ColorScheme.fromSeed(
              seedColor: palette.primaryText, // Primary color
              brightness: palette.brightness,
              primary: palette.primaryText,
              onPrimary: palette.primaryText,
              surface: palette.selectedButtonBackground,
              onSurface: palette.selectedButtonBackground),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: palette.primaryText, // Button text color
            ),
          ),
          textTheme: TextTheme(
            bodyLarge:
                TextStyle(color: palette.normalText), // Default for normal text
            bodyMedium: TextStyle(color: palette.normalText),
            titleLarge: TextStyle(color: palette.primaryText), // Titles
          ),
          primaryColor: palette.primaryText,
          extensions: [palette],
        );
}
