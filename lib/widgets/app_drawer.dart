import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account_screen.dart';
import 'package:haushaltsbuch/screens/categories_screen.dart';
import 'package:haushaltsbuch/screens/settings_screen.dart';
import 'package:haushaltsbuch/screens/standingorders_screen.dart';
import 'package:haushaltsbuch/screens/statistics_screen.dart';
import 'package:haushaltsbuch/screens/transfer_screen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    bool isIOS = false;

    return Drawer(
      child: 
      ListView(
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
            leading: isIOS ? Icon(CupertinoIcons.home) : Icon(Icons.home, size: 36),
            title: Text('Home', style: TextStyle(fontSize: 18)),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.switch_account, size: 36),
            title: Text('Konten', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 0), 
            // async {
            //   // await _auth.signOut();
            //   Navigator.pop(context);
            // },
          ),
          ListTile(
            leading: Icon(Icons.category, size: 36),
            title: Text('Kategorien', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 1), 
          ),
          ListTile(
            leading: Icon(Icons.price_change, size: 36),
            title: Text('Buchen', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 2), 
          ),
          ListTile(
            leading: Icon(Icons.assignment, size: 36),
            title: Text('Daueraufträge', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 3), 
          ),
            ListTile(
            leading: Icon(Icons.stacked_bar_chart, size: 36),
            title: Text('Statistik', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 4), 
          ),
          ListTile(
            leading:  isIOS ? Icon(CupertinoIcons.settings) :  Icon(Icons.settings, size: 36),
            title: Text('Einstellungen', style: TextStyle(fontSize: 18)),
            onTap: () => selectedItem(context, 5), 
          ),
        ],
      ),
    );
  }

  // function for navigating through the menu items
  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop(); //closes the Drawer when navigation to another screen

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountScreen(),
          ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TransferScreen(),
          ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StandingOrdersScreen(),
          ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StatisticsScreen(),
          ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SettingsScreen(),
          ));
        break;
    }
  }
}
