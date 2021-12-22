import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
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
            leading: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: TextButton(
              child: Text('Alle Daten Löschen'),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Alle Daten löschen"),
                      content: const Text(
                          "Bist du WIRKLICH sicher, dass du ALLE Daten löschen willst?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              
                              // AllData.accountTypes = [];
                              // AllData.accounts = [];
                              // AllData.categories = [];
                              // AllData.postings = [];
                              // AllData.standingOrderPostings = [];
                              // AllData.standingOrders = [];
                              // AllData.transfers = [];
                              DBHelper.deleteDatabse();

                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Löschen")),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Abbrechen"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
