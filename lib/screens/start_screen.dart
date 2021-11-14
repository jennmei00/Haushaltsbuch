import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/standing_order_posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/home_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Future<bool> _loadData;

  Future<bool> _getAllData() async {
    AllData.accounts =
       Account().listFromDB(await DBHelper.getData('Account'));

    AllData.categories =
        Category().listFromDB(await DBHelper.getData('Category'));

    AllData.standingOrders =
        StandingOrder().listFromDB(await DBHelper.getData('Standingorder'));

    AllData.accountTypes =
        AccountType().listFromDB(await DBHelper.getData('AccountType'));

    AllData.postings = Posting().listFromDB(await DBHelper.getData('Posting'));

    AllData.standingOrderPostings = StandingOrderPosting()
        .listFromDB(await DBHelper.getData('StandingOrderPosting'));

    AllData.transfers =
        Transfer().listFromDB(await DBHelper.getData('Transfer'));

    return Future.value(true);
  }

  @override
  void initState() {
    // DBHelper.deleteDatabse();
    _loadData = _getAllData();
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
