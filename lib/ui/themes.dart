import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orangeAccent,
    brightness: Brightness.dark,
  ),
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
