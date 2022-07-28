import 'package:flutter/material.dart';

ThemeData themeLight = ThemeData(
  primaryColor: const Color.fromRGBO(144, 83, 235, 1.0),
  fontFamily: 'SF UI Display',
  textTheme: TextTheme(
    // Обычный жирный
    bodyText1: const TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    // Обычный
    bodyText2: const TextStyle(
      color: Colors.black,
      fontSize: 25,
    ),
    // Маленький шрифт светло-серого цвета
    subtitle1: TextStyle(
      color: Colors.grey.shade500,
    ),
    // Маленький шрифт светло-серого цвета
    subtitle2: const TextStyle(
      color: Colors.red,
      fontSize: 25,
    ),
    // Большой жирный белый
    headline2: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 35,
    ),
    // Заголовок
    headline3: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    button: const TextStyle(
      color: Colors.black,
      fontSize: 25,
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.blue,
  ),
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: const Color.fromRGBO(144, 83, 235, 1.0),
      ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      fontSize: 25,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      primary: const Color.fromRGBO(144, 83, 235, 1.0),
      onPrimary: Colors.white,
      minimumSize: const Size.fromHeight(75),
      textStyle: const TextStyle(
        fontSize: 30,
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(144, 83, 235, 1.0),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color.fromRGBO(144, 83, 235, 1.0),
  ),
  // primaryColorDark: Colors.deepOrange[100],
);
