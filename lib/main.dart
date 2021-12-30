import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/management/filter_management_screen.dart';
import 'package:haushaltsbuch/screens/management/management_screen.dart';
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

    Map<int, Color> color = {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };

    return MaterialApp(
      title: 'Haushaltsapp',
      theme: themeNotifier.getTheme(), 
        //ThemeData(
      //   primaryColor: colorSchemeLight.primary,
      //   colorScheme: colorSchemeLight.copyWith(secondary: colorSchemeLight.secondary),
      //   backgroundColor: colorSchemeLight.background,
      //   //primarySwatch: MaterialColor(0xffad1457, color),
      //   //brightness: Brightness.light,
      // ),
      //themeNotifier.getTheme(), 

      // theme: ThemeData(
      //   primaryColor: Colors.red[700],
      //   textTheme: TextTheme(),
      //   buttonTheme: ButtonThemeData()
      // ),
      // themeMode: ThemeMode.system,
      // darkTheme: MyThemes.darkTheme,
      home: StartScreen(ctx: context),
      // HomeScreen(),
      routes: {
        AccountScreen.routeName: (context) => AccountScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        StatisticsScreen.routeName: (context) => StatisticsScreen(),
        //categories
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        // NewCategorieScreen.routeName: (context) => NewCategorieScreen(),
        //standingorders
        StandingOrdersScreen.routeName: (context) => StandingOrdersScreen(),
        // AddEditStandingOrder.routeName: (context) => AddEditStandingOrder(),
        //posting
        PostingScreen.routeName: (context) => PostingScreen(),
        // IncomeScreen.routeName: (context) => IncomeScreen(),
        // TransferScreen.routeName: (context) => TransferScreen(),
        //Account
        //NewAccountScreen.routeName: (context) => NewAccountScreen(),
        //Management
        ManagementScreen.routeName: (context) => ManagementScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == IncomeExpenseScreen.routeName) {
          print(settings.arguments.runtimeType);
          final args = settings.arguments as List<String?>;

          return MaterialPageRoute(
            builder: (context) {
              return IncomeExpenseScreen(
                type: args[0].toString(),
                id: args[1].toString(),
              );
            },
          );
        } else if (settings.name == AddEditStandingOrder.routeName) {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return AddEditStandingOrder(
                id: args,
              );
            },
          );
        } else if (settings.name == NewAccountScreen.routeName) {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return NewAccountScreen(
                id: args,
              );
            },
          );
        } else if (settings.name == NewCategorieScreen.routeName) {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return NewCategorieScreen(
                id: args,
              );
            },
          );
        } else if (settings.name == FilterManagementScreen.routeName) {
          final args = settings.arguments as List<Object?>;
          return MaterialPageRoute(builder: (context) {
            return FilterManagementScreen(
              filters: args,
            );
          });
        } else if (settings.name == TransferScreen.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(builder: (context) {
            return TransferScreen(
              id: args,
            );
          });
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
