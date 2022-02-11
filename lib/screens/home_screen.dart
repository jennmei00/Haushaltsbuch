import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/home_screen';

  //wieder loeschen
  final String id;
  final bool isSOUpdated;
  HomeScreen({this.id = '', this.isSOUpdated = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String value = 'Dein Vermögen beträgt';
  bool showsBalance = false;

  var accountData = AllData.accounts;

  double totalBankBalance = 0;

  void _getTotalBankBalance() {
    accountData.forEach((ac) {
      totalBankBalance += ac.bankBalance!;
    });
    totalBankBalance = double.parse((totalBankBalance).toStringAsFixed(2));
  }

  @override
  void initState() {
    _getTotalBankBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Theme.of(context).primaryColor,
                spreadRadius: 10,
              )
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (!showsBalance) {
                setState(() {
                  value = totalBankBalance.toString() + ' €';
                  showsBalance = true;
                });
              } else {
                setState(() {
                  value = 'Dein Vermögen beträgt';
                  showsBalance = false;
                });
              }
            },
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Handwritingstyle',
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
    // ignore: todo
    //TODO: Cupertino Design
  }
}
