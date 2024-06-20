import 'package:flutter/material.dart';

ThemeData appLightTheme(Color color) => (_AppLightTheme(color)).themeData;
ThemeData appDarkTheme(Color color) => (_AppDarkTheme(color)).themeData;

class _AppLightTheme {
  _AppLightTheme(Color color) : _themeColor = color;

  final Color _themeColor;

  ThemeData get themeData => ThemeData(
        colorScheme: _colorScheme,
        useMaterial3: true,
        fontFamily: 'NotoSansSC',
        fontFamilyFallback: ['Arial'],
      );

  Color get _seedColor => _themeColor;

  ColorScheme get _colorScheme => ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      );
}

class _AppDarkTheme extends _AppLightTheme {
  _AppDarkTheme(super.color);

  @override
  ColorScheme get _colorScheme => ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      );
}
