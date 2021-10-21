import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/start_screen.dart';
import 'package:haushaltsbuch/screens/statistics_screen.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:haushaltsbuch/services/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
      child: MyApp(),
    ));
  });
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Haushaltsapp',
      theme: themeNotifier.getTheme(),
      // ThemeData(
      //   primaryColor: Colors.cyan[700],
      //   textTheme: TextTheme(),
      //   buttonTheme: ButtonThemeData()
      // ),
      // themeMode: ThemeMode.system,
      // darkTheme: MyThemes.darkTheme,
      home: StartScreen(),
      // HomeScreen(),
      routes: {
        AccountScreen.routeName: (context) => AccountScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        StatisticsScreen.routeName: (context) => StatisticsScreen(),
        //categories
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        NewCategorieScreen.routeName: (context) => NewCategorieScreen(),
        //standingorders
        StandingOrdersScreen.routeName: (context) => StandingOrdersScreen(),
        // AddEditStandingOrder.routeName: (context) => AddEditStandingOrder(),
        //posting
        PostingScreen.routeName: (context) => PostingScreen(),
        // IncomeScreen.routeName: (context) => IncomeScreen(),
        TransferScreen.routeName: (context) => TransferScreen(),
        //Account
        NewAccountScreen.routeName: (context) => NewAccountScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == IncomeExpenseScreen.routeName) {
          final args = settings.arguments as String;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return IncomeExpenseScreen(
                type: args,
              );
            },
          );
        } else if (settings.name == AddEditStandingOrder.routeName) {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return AddEditStandingOrder(
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
