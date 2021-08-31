import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static final routeName = '/settings_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Einstellungen'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    body: ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        // SwitchListTile(
        //     secondary: Icon(Icons.lightbulb_outline),
        //     title: Text('Darkmode'),
        //     subtitle: Text(''),
        //     //value: _darkTheme,
        //     onChanged: (val) {
        //       // onThemeChanged(val, themeNotifier);
        //     },
        //   ), 
      ],
    ),
    drawer: AppDrawer(),
  );
}