import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/management/management_screen.dart';
import 'package:haushaltsbuch/screens/settings/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/budget/budget_screen.dart';
import 'package:haushaltsbuch/screens/statistics/statistics_screen.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:localization/localization.dart';

class AppDrawer extends StatelessWidget {
  final String selectedMenuItem;

  AppDrawer({
    required this.selectedMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              Container(
                height: 65,
                child: DrawerHeader(
                  child: Center(
                    child: Text(
                      'menu'.i18n(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.switch_account, size: 36),
                title: Text('accounts'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'accounts'),
                selected: selectedMenuItem == 'accounts' ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.category, size: 36),
                title: Text('categories'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'categories'),
                selected: selectedMenuItem == 'categories' ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.price_change, size: 36),
                title: Text('posting'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'posting'),
                selected: selectedMenuItem == 'posting' ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.assignment, size: 36),
                title: Text('standingorders'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'standingorders'),
                selected: selectedMenuItem == 'standingorders' ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.request_page, size: 36),
                title: Text('management'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'management'),
                selected: selectedMenuItem == 'management' ? true : false,
              ),
              ListTile(
                leading: Icon(Icons.stacked_bar_chart, size: 36),
                title: Text('statistic'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'statistic'),
                selected: selectedMenuItem == 'statistic' ? true : false,
              ),
              // ListTile(
              //   leading: Icon(Icons.savings_rounded, size: 36),
              //   title: Text('Budget', style: TextStyle(fontSize: 18)),
              //   onTap: () => selectedItem(context, 'budget'),
              //   selected: selectedMenuItem == 'budget' ? true : false,
              // ),
              ListTile(
                leading: Icon(Icons.settings, size: 36),
                title: Text('settings'.i18n(), style: TextStyle(fontSize: 18)),
                onTap: () => selectedItem(context, 'settings'),
                selected: selectedMenuItem == 'settings' ? true : false,
              )
            ],
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Version: ${Globals.version}'),
          ),
          alignment: Alignment.bottomRight,
        ),
      ]),
    );
  }

  // function for navigating through the menu items
  void selectedItem(BuildContext context, String screen) {
    Navigator.of(context)
        .pop(); //closes the Drawer when navigation to another screen

    switch (screen) {
      case 'home':
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        break;
      case 'accounts':
        Navigator.of(context).pushReplacementNamed(AccountScreen.routeName);
        break;
      case 'categories':
        Navigator.of(context).pushReplacementNamed(CategoriesScreen.routeName);
        break;
      case 'posting':
        Navigator.of(context).pushReplacementNamed(PostingScreen.routeName);
        break;
      case 'standingorders':
        Navigator.of(context)
            .pushReplacementNamed(StandingOrdersScreen.routeName);
        break;
      case 'statistic':
        Navigator.of(context).pushReplacementNamed(StatisticsScreen.routeName);
        break;
      case 'management':
        Navigator.of(context).pushReplacementNamed(ManagementScreen.routeName);
        break;
      case 'budget':
        Navigator.of(context).pushReplacementNamed(BudgetScreen.routeName);
        break;
      case 'settings':
        Navigator.of(context).pushReplacementNamed(SettingsScreen.routeName);
        break;
    }
  }
}
