import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
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
      .where((key) => key.contains('assets/icons/category_icons')).toList();

  Globals.imagePathsAccountIcons = manifestMap.keys
      .where((key) => key.contains('assets/icons/account_icons')).toList();

  // Globals.otherIcons = manifestMap.keys
  //     .where((key) => key.contains('assets/icons/other_icons')).toList();
}

Future<void> _getThemeMode() async {
    var prefs = await SharedPreferences.getInstance();
    Globals.isDarkmode = prefs.getBool('darkMode')!;
  
}

class _StartScreenState extends State<StartScreen> {
  late Future<bool> _loadData;

  Future<bool> _getAllData() async {
    // await DBHelper.delete('Transfer');

    await _getImageList(widget.ctx as BuildContext);
    AllData.accounts = Account().listFromDB(await DBHelper.getData('Account'));

    AllData.categories =
        Category().listFromDB(await DBHelper.getData('Category'));

    AllData.standingOrders =
        StandingOrder().listFromDB(await DBHelper.getData('Standingorder'));

    AllData.accountTypes =
        AccountType().listFromDB(await DBHelper.getData('AccountType'));

    AllData.postings = Posting().listFromDB(await DBHelper.getData('Posting'));

    // AllData.standingOrderPostings = StandingOrderPosting()
    //     .listFromDB(await DBHelper.getData('StandingOrderPosting'));

    AllData.transfers =
        Transfer().listFromDB(await DBHelper.getData('Transfer'));



    return Future.value(true);
  }

  @override
  void initState() {
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
          return HomeScreen();
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
