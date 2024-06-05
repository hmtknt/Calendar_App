import 'package:flutter/material.dart';

import 'light_color.dart';

class AppTheme {
  const AppTheme();

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: LightColor.primary,
    cardTheme: const CardTheme(color: LightColor.background),
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    dividerColor: LightColor.grey,
    bottomAppBarTheme: const BottomAppBarTheme(color: LightColor.background),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: LightColor.primary,
      secondary: LightColor.secondary,
      surface: LightColor.background,
      error: LightColor.error,
      onPrimary: LightColor.onPrimary,
      onSecondary: LightColor.onSecondary,
      onSurface: LightColor.onSurface,
      onError: LightColor.onError,
    ),
  );

  static TextStyle titleStyle = const TextStyle(color: LightColor.titleTextColor, fontSize: 16);
  static TextStyle subTitleStyle = const TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);

  static TextStyle h1Style = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);

  static List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(horizontal: 10);

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
