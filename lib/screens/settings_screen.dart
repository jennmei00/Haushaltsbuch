import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
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
    )
  );
}