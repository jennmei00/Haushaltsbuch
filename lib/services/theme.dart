import 'package:flutter/material.dart';

final ColorScheme colorSchemeLight = ColorScheme.light(
  primary: Color(
      0xff880e4f), //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
  primaryVariant: Color(0xffbc477b),
  secondary: Color(
      0xff757575), //Color(0xff0097a7), //for example background of loatingActionButton of the AppBAr
  secondaryVariant: Color(0xffe0e0e0), //Color(0xffb2ebf2),//56c8d8),
  background: Colors.white, //(0xffFCE4EC),
  onSecondary: Colors.white,
  //surface: //for example backgroundcolor of the snackbar
);

final lightTheme = ThemeData(
  colorScheme: colorSchemeLight,
  primaryColor: colorSchemeLight.primary,
  primaryColorLight: Color(0xffbc477b),
  primaryColorDark: Color(0xff560027),
  primarySwatch: Colors.grey,
  brightness: colorSchemeLight.brightness,
  scaffoldBackgroundColor: colorSchemeLight.background,
  // appBarTheme: AppBarTheme(backgroundColor: Colors.red[900]),
  toggleableActiveColor: colorSchemeLight
      .secondary, //for example: aktiveColor of the Switch-Widget
  indicatorColor: Colors.white, //for example: of the TabBar
  //floatingActionButtonTheme: FloatingActionButtonThemeData(extendedTextStyle: TextStyle(color: colorSchemeLight.onSecondary)),
  //splashColor: Color(0xffbc477b),
);

final ColorScheme colorSchemeDark = ColorScheme.dark(
  secondary: Color(0xff45ADA8),
  primary: Color(0xff78AD68),
  // secondaryVariant: Color(0xffbc477b),
  // secondary: Color(0xff560027),
);

final darkTheme = ThemeData(
  colorScheme: colorSchemeDark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  iconTheme: IconThemeData(
    color: colorSchemeDark.primary,
  ),
  toggleableActiveColor: colorSchemeDark.secondary,
);
