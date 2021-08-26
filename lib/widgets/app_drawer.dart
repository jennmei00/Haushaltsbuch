import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 15,
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
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            // leading: ,
            title: Text('Konten'),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            // leading: Icon(Icons.),
            title: Text('Statistik'),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            // leading: ,
            title: Text('Daueraufträge'),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen'),
            onTap: () async {
              // await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
