import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, this.ctx}) : super(key: key);

  final BuildContext? ctx;

  @override
  _StartScreenState createState() => _StartScreenState();
}

Future<void> _getImageList(BuildContext context) async {
  //Im DefaultAssetBundle stehen irgendiwe alle ASSETS im JSON-Format drinnen.
  //und mit dem key.contains(...) hole ich nur die aus dem ordner assets/icons/ raus

  String manifestContent =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

  Map<dynamic, dynamic> manifestMap = json.decode(manifestContent);

  Globals.imagePathsCategoryIcons = manifestMap.keys
      .where((key) => key.contains('assets/icons/category_icons'))
      .toList();

  Globals.imagePathsAccountIcons = manifestMap.keys
      .where((key) => key.contains('assets/icons/account_icons'))
      .toList();
}

Future<void> _getThemeMode() async {
  var prefs = await SharedPreferences.getInstance();
  var brightness = SchedulerBinding.instance!.window.platformBrightness;
  Globals.isDarkmode =
      prefs.getBool('darkMode') ?? brightness == Brightness.dark;
}

class _StartScreenState extends State<StartScreen> with WidgetsBindingObserver {
  late Future<bool> _loadData;

  Future<bool> _getAllData() async {
    await _getImageList(widget.ctx as BuildContext);

    AllData.accountTypes =
        AccountType().listFromDB(await DBHelper.getData('AccountType'));

    AllData.categories =
        Category().listFromDB(await DBHelper.getData('Category'));

    // AllData.accounts = [];
    AllData.accounts = Account().listFromDB(await DBHelper.getData('Account'));

    //if AccountVisibility.text does not exist, create it and write data
    if (!await FileHelper().fileExists()) {
      Map<String, bool> map = {};
      AllData.accounts.forEach((element) {
        map[element.id!] = true;
      });
      await FileHelper().writeMap(map);
    }

    Globals.accountVisibility = await FileHelper().readMap();

    AllData.standingOrders =
        StandingOrder().listFromDB(await DBHelper.getData('Standingorder'));

    AllData.postings = Posting().listFromDB(await DBHelper.getData('Posting'));

    AllData.transfers =
        Transfer().listFromDB(await DBHelper.getData('Transfer'));

    updateStandingOrders(context, false);

    precacheImage(AssetImage("assets/images/einnahme.jpg"), context);
    precacheImage(AssetImage("assets/images/ausgabe2.jpg"), context);
    precacheImage(AssetImage("assets/images/umbuchung.jpg"), context);

    return Future.value(true);
  }

  @override
  void initState() {
    // DBHelper.deleteDatabse();
    _loadData = _getAllData();
    _getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return AccountScreen();
        else if (snapshot.hasError)
          return Center(
            child: Text(
                'Sorry, something went wrong :(\nPlease contact the Support.'),
          );
        else
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
      },
    );
  }
}
