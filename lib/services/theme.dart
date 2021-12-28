import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.red[900],
  // brightness: Brightness.light,
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red[200]),
  //shadowColor: Colors.red[200]
  // scaffoldBackgroundColor: Colors.teal[50],
  // backgroundColor: Colors.red[900],
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.red[900], //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
    // secondary: Colors.red[900], //for example background of loatingActionButton of the AppBAr
    // surface: Colors.purple, //for example backgroundcolor of the snackbar
    // background: Colors.orange,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.red[900]),
  toggleableActiveColor:  Colors.red[900], //for example: aktiveColor of the Switch-Widget
  indicatorColor: Colors.red[900], //for example: of the TabBar
  floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red[900]),
   
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
    primary: Colors.red[900], //I think this is the mainColor, for example the backgroundcolor of the appbar or the color of the progressindicator
  //   // secondary: Colors.red[900], //for example background of loatingActionButton of the AppBAr
  //   // surface: Colors.purple, //for example backgroundcolor of the snackbar
  //   // background: Colors.orange,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.red[900]),
  toggleableActiveColor:  Colors.red[900], //for example: aktiveColor of the Switch-Widget
  indicatorColor: Colors.red[900], //for example: of the TabBar
  floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red[900]),
);
