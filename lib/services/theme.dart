import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haushaltsbuch/services/input_theme.dart';

final TextTheme textTheme = TextTheme(
  headlineLarge: GoogleFonts.raleway(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineMedium:
      GoogleFonts.raleway(fontSize: 24, fontWeight: FontWeight.w400),
  headlineSmall: GoogleFonts.raleway(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.raleway(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.raleway(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.sourceCodePro(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.sourceCodePro(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.sourceCodePro(
      fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.sourceCodePro(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.sourceCodePro(
      fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

final ColorScheme colorSchemeLight = ColorScheme.light(
  primary: Color(0xff880e4f),
  secondary: Color(0xff0097a7),
  surface: Colors.white,
  onSecondary: Colors.black,
);

final lightTheme = ThemeData(
  colorScheme: colorSchemeLight,
  primaryColor: colorSchemeLight.primary,
  primaryColorLight: Color(0xffbc477b),
  primaryColorDark: Color(0xff560027),
  primarySwatch: Colors.grey,
  brightness: colorSchemeLight.brightness,
  scaffoldBackgroundColor: colorSchemeLight.surface,
  // indicatorColor: Colors.white,
  inputDecorationTheme: InputTheme().theme(colorSchemeLight),
  tabBarTheme: TabBarThemeData(
    indicatorColor: Colors.white,
  ),
);

final ColorScheme colorSchemeDark = ColorScheme.dark(
  primary: Color(0xff7cc0d8),
  secondary: Color(0xff3ba1c5),
  onPrimary: Colors.black,
  onSecondary: Colors.black,
);

final darkTheme = ThemeData(
    primaryColor: colorSchemeDark.secondary,
    primaryColorDark: Color(0xff1a6985),
    colorScheme: colorSchemeDark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    iconTheme: IconThemeData(color: Colors.grey.shade500),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorSchemeDark.secondary),
    inputDecorationTheme: InputTheme().theme(colorSchemeDark),
    tabBarTheme: TabBarThemeData(
      indicatorColor: colorSchemeDark.secondary,
    ),
    // indicatorColor: colorSchemeDark.secondary
    );
