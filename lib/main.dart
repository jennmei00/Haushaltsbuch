import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/categories_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/statistics_screen.dart';
import 'package:haushaltsbuch/screens/transfer/transfer_screen.dart';

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
      routes: {
        AccountScreen.routeName: (context) => AccountScreen(),
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        StandingOrdersScreen.routeName: (context) => StandingOrdersScreen(),
        StatisticsScreen.routeName: (context) => StatisticsScreen(),
        TransferScreen.routeName: (context) => TransferScreen(),
      },
    );
  }
}
