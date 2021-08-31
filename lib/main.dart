import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/categories_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/statistics_screen.dart';
import 'package:haushaltsbuch/screens/transfer/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/transfer/posting_screen.dart';
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
        //Transfer
        PostingScreen.routeName: (context) => PostingScreen(),
        // IncomeScreen.routeName: (context) => IncomeScreen(),
        TransferScreen.routeName: (context) => TransferScreen(),
        // IncomeScreen.routeName: (BuildContext context) =>
        //             IncomeScreen( 
        //               ModalRoute.of(context)== null ? '':ModalRoute.of(context).settings.arguments.toString()
        //                                     // ModalRoute.of(context).settings.arguments[0].toString()
        //               ),
      },
      onGenerateRoute: (settings) {
        if(settings.name == IncomeExpenseScreen.routeName){

        final args = settings.arguments as String;

      // Then, extract the required data from
      // the arguments and pass the data to the
      // correct screen.
      return MaterialPageRoute(
        builder: (context) {
          print(args);
          return IncomeExpenseScreen(
            type: args,
          );
        },
      );
    }
    assert(false, 'Need to implement ${settings.name}');
    return null;
      },
    );
  }
}
