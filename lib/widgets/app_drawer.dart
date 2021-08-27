import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/account_screen.dart';

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
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.price_change, size: 36),
            title: Text('Buchen', style: TextStyle(fontSize: 18)),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment, size: 36),
            title: Text('Daueraufträge', style: TextStyle(fontSize: 18)),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
            ListTile(
            leading: Icon(Icons.stacked_bar_chart, size: 36),
            title: Text('Statistik', style: TextStyle(fontSize: 18)),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:  isIOS ? Icon(CupertinoIcons.settings) :  Icon(Icons.settings, size: 36),
            title: Text('Einstellungen', style: TextStyle(fontSize: 18)),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // function for navigating through the menu items
  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountScreen(),
          ));
        break;
    }
  }
}
