import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haushaltsbuch/services/input_theme.dart';

final TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.raleway(
      fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.raleway(
      fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.raleway(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.raleway(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.raleway(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.raleway(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.raleway(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.sourceCodePro(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.sourceCodePro(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.sourceCodePro(
      fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.sourceCodePro(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.sourceCodePro(
      fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

final ColorScheme colorSchemeLight = ColorScheme.light(
  primary: Color(
      0xff880e4f), //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
  primaryVariant: Color(0xff560027), //Color(0xffbc477b),

  // secondary: Color(
  //     0xff757575), //Color(0xff0097a7), //for example background of loatingActionButton of the AppBAr
  // secondaryVariant: Color(0xffeeeeee), //Color(0xffb2ebf2),//56c8d8),
  secondary: Color(0xff0097a7),
  secondaryVariant: Color(0xff006978),
  background: Colors.white, //(0xffFCE4EC),
  onSecondary: Colors.black,
  //surface: //for example backgroundcolor of the snackbar
);

final lightTheme = ThemeData(
  textTheme: textTheme,
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
  // cardTheme: CardTheme(
  //   color: Color(0xffeeeeee),
  // ),
  inputDecorationTheme: InputTheme().theme(colorSchemeLight),
);

final ColorScheme colorSchemeDark = ColorScheme.dark(
  primary: Color(0xfff48fb1),
  primaryVariant: Color(0xfff8bbd0),
  secondary: Color(0xff45ADA8),
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  secondaryVariant: Color(0xff00675b),
  // primary: Color(0xff78AD68),
  // primaryVariant: Color(0xffa8df97),
  // secondaryVariant: Color(0xffbc477b),
  // secondary: Color(0xff560027),
);

final darkTheme = ThemeData(
  textTheme: textTheme,
  colorScheme: colorSchemeDark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  iconTheme: IconThemeData(
    color: Colors.grey.shade500,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorSchemeDark.secondary,
  ),
  toggleableActiveColor: colorSchemeDark.secondary,
  inputDecorationTheme: InputTheme().theme(colorSchemeDark),
);