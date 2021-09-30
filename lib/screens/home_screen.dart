import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/test.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = '/home_screen';

  void _openDatabase() {
    DBHelper.openDatabase();
  }

  void _openDirectory() async {
    await getApplicationDocumentsDirectory();
    Directory dir = await getApplicationDocumentsDirectory();
    print(dir);
  }

  @override
  Widget build(BuildContext context) {
    // _openDatabase();
    // DBHelper.insert(
    //     'Tabelle1', Test('52648DFFF568545', 'Variable111111', 45).toMap());

    // DBHelper.getData('Tabelle1');

    // _openDirectory();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      // drawer: Drawer(),
      drawer: AppDrawer(),
      body: Container(
        child: Text("Das ist die Homeseite"),
      ),
    );

    //TODO: Cupertino Design
  }
}
