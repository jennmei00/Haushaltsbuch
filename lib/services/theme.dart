import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.red[900], 
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red[200]),
  //shadowColor: Colors.red[200]
  // scaffoldBackgroundColor: Colors.teal[50],
  backgroundColor: Colors.red[900],
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.cyan[900],
  // accentColor: Colors.cyan[900],
);
