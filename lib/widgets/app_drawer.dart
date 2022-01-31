import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/screens/management/management_screen.dart';
import 'package:haushaltsbuch/screens/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/statistics/statistics_screen.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    // bool isIOS = false;

    return Drawer(
      child: ListView(
        //   physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            height: 65,
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'Menü',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              
            ),
          ),
          //     SwitchListTile(
          //       secondary: Icon(Icons.lightbulb_outline),
          //       title: Text('Darkmode'),
          //       subtitle: Text(''),
          //       value: _darkTheme,
          //       onChanged: (val) {
          //         // onThemeChanged(val, themeNotifier);
          //       },
          //     ),
          ListTile(
            //isIOS ?  Icon(CupertinoIcons.add) :
            leading: Icon(Icons.home, size: 36),
            title: Text('Home', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'home'),
          ),
          ListTile(
            leading: Icon(Icons.switch_account, size: 36),
            title: Text('Konten', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'accounts'),
          ),
          ListTile(
            leading: Icon(Icons.category, size: 36),
            title: Text('Kategorien', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'categories'),
          ),
          ListTile(
            leading: Icon(Icons.price_change, size: 36),
            title: Text('Buchen', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'posting'),
          ),
          ListTile(
            leading: Icon(Icons.assignment, size: 36),
            title: Text('Daueraufträge', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'standingorders'),
          ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart, size: 36),
            title: Text('Statistik', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'statistic'),
          ),
          ListTile(
            leading: Icon(Icons.request_page, size: 36),
            title: Text('Verwaltung', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'management'),
          ),
          ListTile(
            // isIOS? Icon(CupertinoIcons.settings) :
            leading: Icon(Icons.settings, size: 36),
            title: Text('Einstellungen', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 'settings'),
          ),
        ],
      ),
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
      case 'settings':
        Navigator.of(context).pushReplacementNamed(SettingsScreen.routeName);
        break;
    }
  }
}
