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
          textTheme: TextTheme(
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: palette.normalText,
            ),
          ),
          primaryTextTheme: TextTheme(
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: palette.primaryText,
            ),
          ),
          extensions: [palette],
        );
}
