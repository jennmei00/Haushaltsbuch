import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan[700],
      ),
      themeMode: ThemeMode.system,
      // darkTheme: MyThemes.darkTheme,
      home: HomeScreen(),
    );
  }
}
