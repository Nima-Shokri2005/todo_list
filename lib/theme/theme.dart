import 'package:flutter/material.dart';
import 'package:todo_list/theme/color.dart';

class CustomTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: backgroundColor,
      elevation: 0,
    ),
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white, foregroundColor: primaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          } else {
            return secondaryPrimaryColor;
          }
        },
      ),
    ),
  );
}
