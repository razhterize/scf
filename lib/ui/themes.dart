import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color.fromARGB(255, 68, 41, 0),
    onPrimary: Colors.white,
    secondary: Colors.orangeAccent,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Color.fromARGB(255, 18, 9, 0),
    onBackground: Colors.white,
    surface: Colors.orangeAccent.shade700,
    onSurface: Colors.white,
    outline: Colors.white,
  ),
  textTheme: const TextTheme(),
);



ThemeData customTheme({Brightness? brightness, MaterialAccentColor? seed}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed ?? Colors.orangeAccent,
      brightness: brightness ?? Brightness.light,
    ),
  );
}