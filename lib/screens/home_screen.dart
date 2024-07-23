import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:localization/localization.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String value = 'Dein Vermögen beträgt';

  bool showsBalance = false;
  var accountData = AllData.accounts;

  double totalBankBalance = 0;

  // void _getTotalBankBalance() {
  //   accountData.forEach((ac) {
  //     totalBankBalance += ac.bankBalance!;
  //   });
  //   totalBankBalance = double.parse((totalBankBalance).toStringAsFixed(2));
  // }

  void _getTotalBankBalance() {
    accountData.forEach((ac) {
      if (Globals.accountVisibility[ac.id] == true)
        totalBankBalance += ac.bankBalance!;
    });
  }

  @override
  void initState() {
    _getTotalBankBalance();
    super.initState();
  }

  Color _getColorBalance(double balance) {
    if (balance < 0) {
      return Colors.red;
    } else {
      return Theme.of(context).colorScheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'home'.i18n(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(
        selectedMenuItem: 'home',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: [
            Container(
              child: Text(
                '${formatCurrency(totalBankBalance)}',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: _getColorBalance(totalBankBalance),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  GestureDetector(
                    onTap: () => openScreen('posting-income'),
                    child: Column(children: [
                      CircleAvatar(
                        child: Icon(Icons.add),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text('posting'.i18n()),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => openScreen('posting-expense'),
                    child: Column(children: [
                      CircleAvatar(
                        child: Icon(Icons.remove),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text('posting'.i18n()),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => openScreen('transfer'),
                    child: Column(children: [
                      CircleAvatar(
                        child: Icon(Icons.compare_arrows),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text('transfer'.i18n()),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => openScreen('account'),
                    child: Column(children: [
                      CircleAvatar(
                        child: Icon(Icons.account_box),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text('account'.i18n()),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => openScreen('standingorder'),
                    child: Column(children: [
                      CircleAvatar(
                        child: Icon(Icons.text_snippet_sharp),
                        radius: 30,
                      ),
                      SizedBox(height: 10),
                      Text('standingorder'.i18n()),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openScreen(String screen) {
    switch (screen) {
      case 'posting-income':
        Navigator.of(context).pushNamed(IncomeExpenseScreen.routeName,
            arguments: ['Einnahme', '']);
        break;
      case 'posting-expense':
        Navigator.of(context).pushNamed(IncomeExpenseScreen.routeName,
            arguments: ['Ausgabe', '']);
        break;
      case 'transfer':
        Navigator.of(context)
            .pushNamed(TransferScreen.routeName, arguments: '');
        break;
      case 'account':
        Navigator.of(context)
            .pushNamed(NewAccountScreen.routeName, arguments: '');
        break;
      case 'standingorder':
        Navigator.of(context)
            .pushNamed(AddEditStandingOrder.routeName, arguments: '');
        break;
      default:
    }
  }
}
