import 'package:flutter/material.dart';

final appLightTheme = (const _AppLightTheme()).themeData;
final appDarkTheme = (const _AppDarkTheme()).themeData;

class _AppLightTheme {
  const _AppLightTheme();

  ThemeData get themeData => ThemeData(
        colorScheme: _colorScheme,
        useMaterial3: true,
        fontFamily: 'NotoSansSC',
        fontFamilyFallback: ['Arial'],
      );

  Color get _seedColor => Colors.deepPurple;

  ColorScheme get _colorScheme => ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      );
}

class _AppDarkTheme extends _AppLightTheme {
  const _AppDarkTheme();

  @override
  ColorScheme get _colorScheme => ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      );
}
