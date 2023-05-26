import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/screens/account/account_overview_screen.dart';
import 'package:haushaltsbuch/screens/budget/new_budget_screen.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/management/filter_management_screen.dart';
import 'package:haushaltsbuch/screens/management/management_screen.dart';
import 'package:haushaltsbuch/screens/settings/credits_screen.dart';
import 'package:haushaltsbuch/screens/settings/excel_export.dart';
import 'package:haushaltsbuch/screens/settings/imprint_screen.dart';
import 'package:haushaltsbuch/screens/settings/settings_screen.dart';
import 'package:haushaltsbuch/screens/signup/login_screen.dart';
import 'package:haushaltsbuch/screens/signup/signup_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/start_screen.dart';
import 'package:haushaltsbuch/screens/budget/budget_screen.dart';
import 'package:haushaltsbuch/screens/statistics/statistics_screen.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:haushaltsbuch/services/theme_notifier.dart';
import 'package:localization/localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    FileHelper().writeAppLog(
        AppLog(details.exceptionAsString().toString(), 'FlutterError'));
  };

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // LicenseRegistry.addLicense(() async* {
  //   final license = await rootBundle.loadString('fonts/OFL.txt');
  //   yield LicenseEntryWithLineBreaks(['fonts'], license);
  // });
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  Globals.appName = packageInfo.appName;
  Globals.packageName = packageInfo.packageName;
  Globals.version = packageInfo.version;
  Globals.buildNumber = packageInfo.buildNumber;

  SharedPreferences.getInstance().then((prefs) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    var darkModeOn = prefs.getBool('darkMode') ?? brightness == Brightness.dark;
    runApp(Phoenix(
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateStandingOrders(context, true);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Haushaltsbuch',
      theme: themeNotifier.getTheme(),
      builder: (BuildContext context, Widget? widget) {
        Widget error = Text('error-text'.i18n());
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget!;
      },
      home: StartScreen(ctx: context),
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // delegate from localization package.
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        // define en_US as default when de language code is 'en'
        if (locale?.languageCode == 'en') {
          return Locale('en', 'US');
        }

        // default language
        return Locale('de', 'DE');
      },
      routes: {
        AccountScreen.routeName: (context) => AccountScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        StatisticsScreen.routeName: (context) => StatisticsScreen(),
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        StandingOrdersScreen.routeName: (context) => StandingOrdersScreen(),
        PostingScreen.routeName: (context) => PostingScreen(),
        ManagementScreen.routeName: (context) => ManagementScreen(),
        BudgetScreen.routeName: (context) => BudgetScreen(),
        ExcelExport.routeName: (context) => ExcelExport(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == IncomeExpenseScreen.routeName) {
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
        } else if (settings.name == AccountOverviewScreen.routeName) {
          final args = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) {
              return AccountOverviewScreen(
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
        } else if (settings.name == Imprint.routeName) {
          return MaterialPageRoute(builder: (context) {
            return Imprint();
          });
        } else if (settings.name == Credits.routeName) {
          return MaterialPageRoute(builder: (context) {
            return Credits();
          });
        } else if (settings.name == BudgetScreen.routeName) {
          return MaterialPageRoute(builder: (context) {
            return BudgetScreen();
          });
        } else if (settings.name == NewBudgetScreen.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(builder: (context) {
            return NewBudgetScreen(
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
