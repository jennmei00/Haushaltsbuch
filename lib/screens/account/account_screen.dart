import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/account/account_overview_screen.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

class AccountScreen extends StatefulWidget {
  static final routeName = '/account_screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<List<Object>> accountTypeList = [];
  bool _initiallyExpanded = false;
  ValueKey? _expansionTileKey;

  var accountData = AllData.accounts;
  // Map<String, bool> _accountVisibility = Map();

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
      if (Globals.accountVisibility[ac.id] == true)
        totalBankBalance += ac.bankBalance!;
    });
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
      return Colors.red;
    } else {
      return Theme.of(context).colorScheme.onSurface;
    }
  }

  @override
  void initState() {
    AllData.accounts.sort((obj, obj2) => obj2.title!.compareTo(obj.title!));
    _createAccountList();
    _getTotalBankBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(NewAccountScreen.routeName, arguments: '');
          },
        ),
        appBar: AppBar(
          title: Text('accounts'.i18n()),
          // title: Text('welcome-text'.i18n()),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _expansionTileKey = ValueKey(Random().nextInt(99));
                    _initiallyExpanded = !_initiallyExpanded;
                  });
                },
                icon: _initiallyExpanded
                    ? Icon(Icons.keyboard_double_arrow_up)
                    : Icon(Icons.keyboard_double_arrow_down)),
          ],
        ),
        drawer: AppDrawer(selectedMenuItem: 'accounts'),
        body: AllData.accounts.length == 0
            ? NothingThere(textScreen: 'no-accounts'.i18n())
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'all-accounts'.i18n(),
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${formatCurrency(totalBankBalance)}',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getColorBalance(totalBankBalance)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: accountTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          AccountType itemAccountType =
                              accountTypeList[index][0] as AccountType;
                          return Card(
                            elevation: 3,
                            color:
                                Globals.isDarkmode ? null : Color(0xffeeeeee),
                            child: ExpansionTile(
                              key: _expansionTileKey,
                              // key: GlobalKey(),
                              initiallyExpanded: _initiallyExpanded,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${itemAccountType.title}'),
                                  Text(
                                      '${formatCurrency(accountTypeList[index][1] as double)}'),
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
                                                Text("delete-account".i18n()),
                                            content: Text(
                                                "delete-account-text".i18n()),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "delete-link"
                                                                    .i18n()),
                                                            content: Text(
                                                                "delete-link-text"
                                                                    .i18n()),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed: () =>
                                                                      _deleteAccount(
                                                                          true,
                                                                          e),
                                                                  child: Text(
                                                                      "delete"
                                                                          .i18n())),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    _deleteAccount(
                                                                        false,
                                                                        e),
                                                                child: Text(
                                                                    "only-account"
                                                                        .i18n()),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Text("delete".i18n())),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text("cancel".i18n()),
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
                                  key: ValueKey<String>(e.id.toString()),
                                  background: Container(
                                    color: Globals.isDarkmode
                                        ? Globals.dismissibleEditColorLDark
                                        : Globals.dismissibleEditColorLight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          Text('edit'.i18n(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    color: Globals.isDarkmode
                                        ? Globals.dismissibleDeleteColorDark
                                        : Globals.dismissibleDeleteColorLight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Text('delete'.i18n(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          AccountOverviewScreen.routeName,
                                          arguments: e.id);
                                    },
                                    child: Card(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      margin: EdgeInsets.all(0),
                                      child: ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: getColor(e.color!)
                                                  .withOpacity(0.20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.asset(
                                                e.symbol!,
                                                color: getColor(e.color!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          '${e.title}',
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${formatCurrency(e.bankBalance!)}',
                                              style: TextStyle(
                                                  color: _getColorBalance(
                                                      e.bankBalance!)),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                bool value = Globals
                                                    .accountVisibility[e.id]!;
                                                Globals.accountVisibility[
                                                    e.id!] = !value;

                                                FileHelper().writeMap(
                                                    Globals.accountVisibility);

                                                totalBankBalance = 0;
                                                _getTotalBankBalance();
                                                setState(() {});
                                              },
                                              icon: Icon(Globals
                                                              .accountVisibility[
                                                          e.id] ==
                                                      true
                                                  ? Icons.visibility_rounded
                                                  : Globals.accountVisibility[
                                                              e.id] ==
                                                          false
                                                      ? Icons.visibility_off
                                                      : Icons.star),
                                            ),
                                          ],
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

  void _deleteAccount(bool withPostings, Account account) async {
    if (withPostings) {
      //Delete Postings
      AllData.postings.removeWhere((element) =>
          element.account != null ? element.account!.id == account.id : false);
      await DBHelper.delete('Posting', where: "AccountID = '${account.id}'");
    } else {
      //Account from postings to null
      List<Posting> accountPostings = AllData.postings
          .where((element) => element.account != null
              ? element.account!.id == account.id
              : false)
          .toList();

      accountPostings.forEach((posting) async {
        AllData
            .postings[AllData.postings
                .indexWhere((element) => element.id == posting.id)]
            .account = null;

        posting.account = null;
        posting.standingOrder = null;

        await DBHelper.update('Posting', posting.toMap(),
            where: "ID = '${posting.id}'");
      });
    }
    //Transfer Account to null
    List<Transfer> accountTransfersFrom = [];
    accountTransfersFrom.addAll(AllData.transfers.where((element) =>
        element.accountFrom == null
            ? false
            : element.accountFrom!.id == account.id));

    List<Transfer> accountTransfersTo = [];
    accountTransfersTo.addAll(AllData.transfers.where((element) =>
        element.accountTo == null
            ? false
            : element.accountTo!.id == account.id));

    accountTransfersFrom.forEach((transfer) async {
      AllData
          .transfers[AllData.transfers.indexWhere((element) =>
              element.accountFrom == null
                  ? false
                  : element.accountFrom!.id == transfer.accountFrom!.id)]
          .accountFrom = null;

      if (transfer.accountFrom != null) {
        if (transfer.accountFrom!.id == account.id) {
          transfer.accountFrom = null;
          transfer.standingOrder = null;
        }
      }

      await DBHelper.update('Transfer', transfer.toMap(),
          where: "ID = '${transfer.id}'");
    });

    accountTransfersTo.forEach((transfer) async {
      AllData
          .transfers[AllData.transfers.indexWhere((element) =>
              element.accountTo == null
                  ? false
                  : element.accountTo!.id == transfer.accountTo!.id)]
          .accountTo = null;

      if (transfer.accountTo != null) {
        if (transfer.accountTo!.id == account.id) {
          transfer.accountTo = null;
          transfer.standingOrder = null;
        }
      }

      await DBHelper.update('Transfer', transfer.toMap(),
          where: "ID = '${transfer.id}'");
    });

    //Delete StandingOrders
    //Postings
    AllData.standingOrders.removeWhere((element) =>
        element.account == null ? false : element.account!.id == account.id);
    await DBHelper.delete('StandingOrder',
        where: "AccountID = '${account.id}'");
    //Transfers
    AllData.standingOrders.removeWhere((element) =>
        element.account == null ? false : element.accountTo!.id == account.id);
    await DBHelper.delete('StandingOrder',
        where: "AccountToID = '${account.id}'");

    //Delete AccountVisibility
    Globals.accountVisibility.remove(account.id);
    FileHelper().writeMap(Globals.accountVisibility);

    //Delete Account
    AllData.accounts.removeWhere((element) => element.id == account.id);
    await DBHelper.delete('Account', where: "ID = '${account.id}'");

    Navigator.of(context)
      ..pop()
      ..popAndPushNamed(AccountScreen.routeName);
  }
}
