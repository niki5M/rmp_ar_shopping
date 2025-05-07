import 'package:flutter/material.dart';
import 'package:testik2/core/theme/colors.dart';

class AppTheme{

  static _border ([Color color = Palete.lightPrimaryColor]) => OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(15),
  );

  // Светлая тема
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Palete.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Palete.lightBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: Palete.textColor),
      titleTextStyle: const TextStyle(
        color: Palete.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _border(),
      focusedBorder: _border(Palete.lightPrimaryColor),
      hintStyle: const TextStyle(color: Palete.greyColor),
      labelStyle: const TextStyle(color: Palete.textColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Palete.textColor),
      bodyMedium: TextStyle(color: Palete.textColor),
    ),
  );

  static ButtonStyle get authButtonStyle => ElevatedButton.styleFrom(
    fixedSize: const Size(395, 55),
    side: BorderSide(
      color: Palete.lightPrimaryColor,
      width: 2,
    ),
    backgroundColor: Colors.white,
    foregroundColor: Palete.lightPrimaryColor,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    fixedSize: const Size(double.infinity, 55),
    backgroundColor: Palete.lightPrimaryColor,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    fixedSize: const Size(double.infinity, 55),
    side: BorderSide(
      color: Palete.lightPrimaryColor,
      width: 2,
    ),
    backgroundColor: Colors.transparent,
    foregroundColor: Palete.lightPrimaryColor,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palete.background,
    appBarTheme: AppBarTheme(
      backgroundColor: Palete.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      color: Palete.blackColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _border(Colors.grey.shade700),
      focusedBorder: _border(Palete.primaryOrange),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      labelStyle: const TextStyle(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}