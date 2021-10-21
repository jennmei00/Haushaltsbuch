import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:haushaltsbuch/services/theme_notifier.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  static final routeName = '/settings_screen';
   bool _darkTheme = false;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SwitchListTile(
            secondary: Icon(Icons.lightbulb),
            title: Text('Darkmode'),
            // subtitle: Text(''),
            value: _darkTheme,
            onChanged: (val) {
              onThemeChanged(val, themeNotifier);
            },
          ),
          //
          //
          //  more settings
          //
          //
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Alle Daten Löschen'),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
