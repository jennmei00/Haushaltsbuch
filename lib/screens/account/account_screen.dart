import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class AccountScreen extends StatefulWidget {
  static final routeName = '/account_screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<AccountType> accountTypeList = [];
  var accountData = AllData.accounts;
  double totalBankBalance = 0;
  void _createAccountList() {
    accountData.forEach((ac) {
      if (accountTypeList
              .where((element) => element.id == ac.accountType!.id)
              .length ==
          0) {
        accountTypeList.add(ac.accountType as AccountType);
      }
    });
  }

  void _getTotalBankBalance() {
    accountData.forEach((ac) {
      totalBankBalance += ac.bankBalance!;
    });
    totalBankBalance = double.parse((totalBankBalance).toStringAsFixed(2));
  }

  Color _getColorBalance(double balance) {
    if (balance < 0) {
      return Colors.red.shade900;
    } else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    _createAccountList();
    _getTotalBankBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[200],
          child: Icon(Icons.add),
          onPressed: () {
            //print(accountData);
            Navigator.of(context).pushNamed(NewAccountScreen.routeName);
          },
        ),
        appBar: AppBar(
            title: Text('Konten'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        drawer: AppDrawer(),
        body: AllData.accounts.length == 0
            ? NothingThere(textScreen: 'Noch keine Konten vorhanden :(')
            : Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Gesamtes Vermögen:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$totalBankBalance €',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getColorBalance(totalBankBalance)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: accountTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ExpansionTile(
                              textColor: Colors.black,
                              iconColor: Colors.black,
                              initiallyExpanded: false,
                              title: Text('${accountTypeList[index].title}'),
                              children: AllData.accounts
                                  .where((element) =>
                                      element.accountType!.id ==
                                      accountTypeList[index].id)
                                  .map((e) {
                                return Card(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.cyan[50],
                                  child: ListTile(
                                    title: Text(
                                      '${e.title}',
                                    ),
                                    trailing: Text(
                                      '${e.bankBalance} €',
                                      style: TextStyle(
                                          color: _getColorBalance(e.bankBalance!)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ));
  }
}
