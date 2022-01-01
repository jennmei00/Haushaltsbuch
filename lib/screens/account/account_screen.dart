import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  static final routeName = '/account_screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<List<Object>> accountTypeList = [];
  late bool isDarkmode;

  var accountData = AllData.accounts;
  double totalBankBalance = 0;
  void _createAccountList() {
    accountData.forEach((ac) {
      if (accountTypeList.where((element) {
            //check if accountType already in list
            AccountType at = element[0] as AccountType;
            return at.id == ac.accountType!.id;
          }).length ==
          0) {
        accountTypeList.add([
          ac.accountType as AccountType,
          _getTotalBankBalanceForSpecificAcType(ac.accountType!.title as String)
        ]);
      }
    });
  }

  void _getTotalBankBalance() {
    accountData.forEach((ac) {
      totalBankBalance += ac.bankBalance!;
    });
    totalBankBalance = double.parse((totalBankBalance).toStringAsFixed(2));
  }

  double _getTotalBankBalanceForSpecificAcType(String acType) {
    double total = 0;
    accountData.forEach((ac) {
      if (ac.accountType!.title == acType) {
        total += ac.bankBalance!;
      }
    });
    return total;
  }

  Color _getColorBalance(double balance) {
    if (balance < 0) {
      return Colors.red.shade900;
    } else {
      return Theme.of(context).colorScheme.onSurface;//Colors.black;
    }
  }

  void _getThemeMode() async {
    var prefs = await SharedPreferences.getInstance();
    isDarkmode = prefs.getBool('darkMode')!;
  }

  @override
  void initState() {
    _createAccountList();
    _getTotalBankBalance();
    _getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          //backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            //print(accountData);
            Navigator.of(context)
                .pushNamed(NewAccountScreen.routeName, arguments: '');
          },
        ),
        appBar: AppBar(
          title: Text('Konten'),
          centerTitle: true,
          // backgroundColor: Theme.of(context).primaryColor),
        ),
        drawer: AppDrawer(),
        body: AllData.accounts.length == 0
            ? NothingThere(textScreen: 'Noch keine Konten vorhanden :(')
            : Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _getColorBalance(totalBankBalance)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: accountTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          AccountType itemAccountType =
                              accountTypeList[index][0] as AccountType;
                          String itemAccountTypeBalance =
                              accountTypeList[index][1].toString();
                          return Card(
                            elevation: 3,
                            color: Theme.of(context).colorScheme.secondaryVariant,
                            child: ExpansionTile(
                              //collapsedBackgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                              //textColor: Colors.black,
                              //iconColor: Colors.black,
                              initiallyExpanded: false,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${itemAccountType.title}'),
                                  Text(itemAccountTypeBalance + ' €'),
                                ],
                              ),
                              children: AllData.accounts
                                  .where((element) =>
                                      element.accountType!.id ==
                                      itemAccountType.id)
                                  .map((e) {
                                return Dismissible(
                                  confirmDismiss: (DismissDirection direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text("Buchung löschen"),
                                            content: const Text(
                                                "Bist du sicher, dass die Buchung löschen willst?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text("Löschen")),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("Abbrechen"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          NewAccountScreen.routeName,
                                          arguments: e.id);
                                      return Future.value(false);
                                    }
                                  },
                                  onDismissed: (DismissDirection direction) {
                                    // if (direction ==
                                    //     DismissDirection.endToStart) {
                                    //   AllData.standingOrders.remove(e);

                                    //   DBHelper.delete('StandingOrder',
                                    //       where: "ID = '${e.id}'");
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(SnackBar(
                                    //           content: Text(
                                    //               'Dauerauftrag wurde gelöscht')));
                                    //   setState(() {});
                                    // }
                                  },
                                  key: ValueKey<String>(e.id.toString()),
                                  background: Container(
                                    color: Colors.orange,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.edit,
                                            //color: Colors.white,
                                          ),
                                          Text('Edit',
                                              style: TextStyle(
                                                  //color: Colors.white,
                                                  )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            //color: Colors.white,
                                          ),
                                          Text('Move to trash',
                                              style: TextStyle(
                                                //color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _showAccountDetails(e),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      margin: EdgeInsets.all(0),
                                      //color: ,
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: Image.asset(e.symbol!,
                                                  color: e.color!),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${e.title}',
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          '${e.bankBalance} €',
                                          style: TextStyle(
                                              color: _getColorBalance(
                                                  e.bankBalance!)),
                                        ),
                                      ),
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

  void _showAccountDetails(Account account) {
    print(account.symbol);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: account.title!,
            body:
                // Padding(
                //     padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                //     child: Container(
                //       height: MediaQuery.of(context).size.height*0.4,
                //       width: MediaQuery.of(context).size.width*0.8,
                //       child: Stack(
                //         //clipBehavior: Clip.antiAlias,
                //         children: [
                //         Positioned(
                //           left: -50,
                //           bottom: -50,
                //           child: CircleAvatar(
                //             backgroundColor: Colors.lightGreen.shade400,
                //             radius: MediaQuery.of(context).size.width * 0.3,
                //             child: FractionallySizedBox(
                //               widthFactor: 0.65,
                //               heightFactor: 0.65,
                //               child: Image.asset(
                //                 'assets/icons/money-bag.png',
                //               ),
                //             )),
                //         ),
                //         Text(
                //           '- ' + account.accountType!.title! + ' -',
                //           style: TextStyle(fontSize: 20),
                //         ),
                //         Container(
                //           padding: const EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(8),
                //               color: Colors.cyan[100],
                //               boxShadow: [
                //                 BoxShadow(
                //                   blurRadius: 10,
                //                   color: Colors.cyan.shade100,
                //                   spreadRadius: 5,
                //                 ),
                //               ]),
                //           child: Text(account.bankBalance.toString() + ' €',
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 color: _getColorBalance(account.bankBalance!),
                //               )),
                //         ),
                //       ]),
                //     )
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '- ' + account.accountType!.title! + ' -',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        //color: Colors.cyan[100],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            //color: Colors.cyan.shade100,
                            spreadRadius: 5,
                          ),
                        ]),
                    child: Text(account.bankBalance.toString() + ' €',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getColorBalance(account.bankBalance!),
                        )),
                  ),
                ),
                //SizedBox(height: 20),
                if (account.description! != '' && account.description != null)
                  SizedBox(height: 20),
                Text(
                  account.description!,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            //),
            saveButton: false,
            cancelButton: false,
          );
        });
  }
}
