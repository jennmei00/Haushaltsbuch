import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
    // await DBHelper.deleteDatabse();

    await _getImageList(widget.ctx as BuildContext);

    AllData.accountTypes =
        AccountType().listFromDB(await DBHelper.getData('AccountType'));

    AllData.categories =
        Category().listFromDB(await DBHelper.getData('Category'));

    AllData.accounts = Account().listFromDB(await DBHelper.getData('Account'));

    AllData.standingOrders =
        StandingOrder().listFromDB(await DBHelper.getData('Standingorder'));

    AllData.postings = Posting().listFromDB(await DBHelper.getData('Posting'));

    // AllData.standingOrderPostings = StandingOrderPosting()
    //     .listFromDB(await DBHelper.getData('StandingOrderPosting'));

    AllData.transfers =
        Transfer().listFromDB(await DBHelper.getData('Transfer'));

    await _updateStandingOrderPostings();

    return Future.value(true);
  }

  Future<void> _updateStandingOrderPostings() async {
    AllData.postings.sort((obj, obj2) => obj2.date!.compareTo(obj.date!));

    AllData.standingOrders.forEach((element) async {
      Posting? lastPosting;
      // Posting?
      try {
        lastPosting = AllData.postings.length == 0
            ? null
            : AllData.postings.lastWhere(((elementPosting) =>
                elementPosting.standingOrder == null
                    ? false
                    : elementPosting.standingOrder?.id == element.id));
      } catch (ex) {}

      if (element.repetition == Repetition.weekly) {
        DateTime? date;
        if (lastPosting != null && lastPosting != Posting())
          date = lastPosting.date as DateTime;
        else
          date = element.begin!.subtract(Duration(days: 7));
        Duration difference = DateTime.now().difference(date);
        if (difference.inDays / 7 >= 1) {
          int missing = (difference.inDays / 7).floor();

          for (var i = 0; i < missing; i++) {
            date = date!.add(Duration(days: 7));
            await _addPosting(element, date);
          }
        }
      } else if (element.repetition == Repetition.monthly) {
        DateTime? date;
        if (lastPosting != null && lastPosting != Posting())
          date = lastPosting.date;
        else {
          if (element.begin!.isBefore(DateTime.now())) {
            await _addPosting(element, element.begin!);
          }
          date = element.begin!;
        }
        int i = 1;
        while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
          await _addPosting(element, Jiffy(date).add(months: i).dateTime);
          i++;
        }
      } else if (element.repetition == Repetition.quarterly) {
        DateTime? date;
        if (lastPosting != null && lastPosting != Posting())
          date = lastPosting.date;
        else {
          if (element.begin!.isBefore(DateTime.now())) {
            await _addPosting(element, element.begin!);
          }
          date = element.begin!;
        }
        int i = 3;
        while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
          await _addPosting(element, Jiffy(date).add(months: i).dateTime);
          i += 3;
        }
      } else if (element.repetition == Repetition.halfYearly) {
        DateTime? date;
        if (lastPosting != null && lastPosting != Posting())
          date = lastPosting.date;
        else {
          if (element.begin!.isBefore(DateTime.now())) {
            await _addPosting(element, element.begin!);
          }
          date = element.begin!;
        }
        int i = 6;
        while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
          await _addPosting(element, Jiffy(date).add(months: i).dateTime);
          i += 6;
        }
      } else if (element.repetition == Repetition.yearly) {
        DateTime? date;
        if (lastPosting != null && lastPosting != Posting())
          date = lastPosting.date;
        else {
          if (element.begin!.isBefore(DateTime.now())) {
            await _addPosting(element, element.begin!);
          }
          date = element.begin!;
        }
        int i = 1;
        while (Jiffy(date).add(years: i).dateTime.isBefore(DateTime.now())) {
          await _addPosting(element, Jiffy(date).add(years: i).dateTime);
          i++;
        }
      }
    });
  }

  Future<void> _addPosting(StandingOrder element, DateTime date) async {
    Posting p = Posting(
      id: Uuid().v1(),
      title: element.title,
      description: element.description,
      account: element.account,
      amount: element.amount,
      date: date,
      postingType: element.postingType,
      category: element.category,
      accountName: element.account?.title,
      standingOrder: element,
      isStandingOrder: true,
    );

    AllData.postings.add(p);
    await DBHelper.insert('Posting', p.toMap());

    //update AccountAmount
    Account ac =
        AllData.accounts.firstWhere((element) => element.id == p.account!.id);
    if (p.postingType == PostingType.income)
      AllData
          .accounts[
              AllData.accounts.indexWhere((element) => element.id == ac.id)]
          .bankBalance = ac.bankBalance! + p.amount!;
    else
      AllData
          .accounts[
              AllData.accounts.indexWhere((element) => element.id == ac.id)]
          .bankBalance = ac.bankBalance! - p.amount!;

    await DBHelper.update('Account', ac.toMap(), where: "ID = '${ac.id}'");
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
