import 'package:flutter/material.dart';

 final ColorScheme colorSchemeLight = ColorScheme.light(
    primary: Color(0xff880e4f),
    primaryVariant: Color(0xffbc477b),
    secondary: Color(0xff0097a7),
    secondaryVariant: Color(0xff56c8d8),
    background: Colors.white,//(0xffFCE4EC),
  );

final lightTheme = ThemeData(
  // brightness: Brightness.light,
  // primaryColor: Color(0xFFad1457),
  // primaryColorLight: Color(0xfe35183),
  // brightness: Brightness.light,
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red[200]),
  //shadowColor: Colors.red[200]
  // scaffoldBackgroundColor: Colors.teal[50],
  // backgroundColor: Colors.red[900],
  //colorScheme: ColorScheme.fromSwatch().copyWith(
  //primary: Color(0xFFad1457), //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
  // secondary: Colors.red[900], //for example background of loatingActionButton of the AppBAr
  // surface: Colors.purple, //for example backgroundcolor of the snackbar
  // background: Colors.orange,
  //primaryVariant: Color(0xff78002e),
  //),
  colorScheme: colorSchemeLight,
  primaryColor: colorSchemeLight.primary,
  primarySwatch: Colors.grey,
  brightness: colorSchemeLight.brightness,
  scaffoldBackgroundColor: colorSchemeLight.background,
  // appBarTheme: AppBarTheme(backgroundColor: Colors.red[900]),
  toggleableActiveColor: colorSchemeLight.secondary, //for example: aktiveColor of the Switch-Widget
  indicatorColor: Colors.white, //for example: of the TabBar
  // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red[900]),
);

final darkTheme = ThemeData(
  // brightness: Brightness.dark,
  // primaryColor: Colors.red[900],
  // // brightness: Brightness.light,
  // // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red[200]),
  // //shadowColor: Colors.red[200]
  // // scaffoldBackgroundColor: Colors.teal[50],
  // // backgroundColor: Colors.red[900],
  colorScheme: ColorScheme.fromSwatch().copyWith(
    brightness: Brightness.dark,
    primary: Colors.red[
        900], //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
    //   // secondary: Colors.red[900], //for example background of loatingActionButton of the AppBAr
    //   // surface: Colors.purple, //for example backgroundcolor of the snackbar
    //   // background: Colors.orange,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.red[900]),
  toggleableActiveColor:
      Colors.red[900], //for example: aktiveColor of the Switch-Widget
  indicatorColor: Colors.red[900], //for example: of the TabBar
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Colors.red[900]),
);
