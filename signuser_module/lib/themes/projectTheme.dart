import 'package:flutter/material.dart';

final ThemeData themeYaText = ThemeData(
  textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      )),
  colorScheme: const ColorScheme.dark(),
);

final ThemeData themeYaButton = ThemeData(
    buttonTheme: ButtonThemeData(
  buttonColor: Colors.blue[900],
  textTheme: ButtonTextTheme.primary,
));

final ThemeData projectTheme = ThemeData(
  primarySwatch: Colors.cyan,
  colorScheme: const ColorScheme.dark(),
).copyWith(
  textTheme: themeYaText.textTheme,
  buttonTheme: themeYaButton.buttonTheme,
);
