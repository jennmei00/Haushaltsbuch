import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:localization/localization.dart';

class AccountOverviewScreen extends StatefulWidget {
  static final routeName = '/account_overview_screen';

  final String id;

  AccountOverviewScreen({this.id = ''});

  @override
  _AccountOverviewScreenState createState() => _AccountOverviewScreenState();
}

class _AccountOverviewScreenState extends State<AccountOverviewScreen> {
  late String _accountTitle = '';
  late double _accountBalance;
  late String _accountDescription = '';
  late Color _accountColor;
  late String _accountSymbol;
  late AccountType _accountType;
  late String _accountID;

  final List<Object> _listPostingsTransfers = [];

  void _getAccountData() {
    Account ac =
        AllData.accounts.firstWhere((element) => element.id == widget.id);
    _accountTitle = ac.title!;
    _accountBalance = ac.bankBalance!;
    _accountDescription = ac.description!;
    _accountColor = ac.color!;
    _accountSymbol = ac.symbol!;
    _accountType = ac.accountType!;
    _accountID = ac.id!;
  }

  void _getPostingsAndTransfers() {
    AllData.postings.forEach((element) {
      if (element.account != null) {
        if (element.account!.id == _accountID) {
          _listPostingsTransfers.add(element);
        }
      }
    });
    AllData.transfers.forEach((element) {
      if (element.accountFrom != null) {
        if (element.accountFrom!.id == _accountID) {
          _listPostingsTransfers.add(element);
        }
      }
      if (element.accountTo != null) {
        if (element.accountTo!.id == _accountID) {
          _listPostingsTransfers.add(element);
        }
      }
    });
  }

  @override
  void initState() {
    _getAccountData();
    _getPostingsAndTransfers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _listPostingsTransfers.sort((obj, obj2) => obj2 is Posting
        ? obj2.date!.compareTo(obj is Posting
            ? obj.date!
            : obj is Transfer
                ? obj.date!
                : DateTime(2020))
        : obj2 is Transfer
            ? obj2.date!.compareTo(obj is Posting
                ? obj.date!
                : obj is Transfer
                    ? obj.date!
                    : DateTime(2020))
            : DateTime(2020).compareTo(DateTime(2020)));
    return Scaffold(
      appBar: AppBar(
        title: Text('account-overview'.i18n()),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _accountTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: textTheme.headline5,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        _accountType.title!,
                        style: textTheme.subtitle1,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.height * 0.08,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: getColor(_accountColor).withOpacity(0.20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        _accountSymbol,
                        color: getColor(_accountColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors
                      .grey 
                      .withOpacity(0.15),
                  border: Border.all(
                    color: getColor(_accountColor),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    formatCurrency(_accountBalance),
                    style: TextStyle(
                      color: _accountBalance < 0
                          ? Colors.red
                          : Theme.of(context)
                              .colorScheme
                              .onSurface,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_accountDescription != '') Divider(),
            if (_accountDescription != '')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    _accountDescription,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            if (_listPostingsTransfers.length != 0)
              Center(
                child: Text(
                  'transactions'.i18n(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getColor(_accountColor)),
                ),
              ),
            if (_listPostingsTransfers.length != 0)
              SizedBox(
                height: 10,
              ),
            if (_listPostingsTransfers.length != 0)
              Expanded(
                child: ListView(
                  children: _listPostingsTransfers.map((Object e) {
                    return _listViewWidget(e, context);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _listViewWidget(Object listObj, context) {
    return Card(
      child: listObj is Posting
          ? ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: getColor(listObj.category!.color!).withOpacity(0.20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    listObj.category!.symbol!,
                    color: getColor(listObj.category!.color!),
                  ),
                ),
              ),
              title: Text(
                '${listObj.title}',
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
              subtitle: Text(
                '${formatDate(listObj.date!, context)}',
                style: TextStyle(color: Colors.grey.shade400),
              ),
              trailing: listObj.postingType == PostingType.income
                  ? Text(
                      '+ ' + formatCurrency(listObj.amount!),
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      '- ' + formatCurrency(listObj.amount!),
                      style: TextStyle(color: Colors.red),
                    ),
              childrenPadding:
                  EdgeInsets.only(left: 20, bottom: 10, right: 10, top: 10),
              expandedAlignment: Alignment.topLeft,
              children: [
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text('Kategorie:'),
                        Text('${listObj.category!.title}'),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Datum:'),
                        Text(formatDate(listObj.date!, context)),
                      ],
                    ),
                    if (listObj.description != '')
                      TableRow(
                        children: [
                          Text('Beschreibung:'),
                          Text(
                            '${listObj.description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            softWrap: false,
                          ),
                        ],
                      )
                  ],
                )
              ],
            )
          : listObj is Transfer
              ? ExpansionTile(
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8,
                            0.0), // 10% of the width, so there are ten blinds.
                        colors: <Color>[
                          getColor(getAccountColorFromAccountName(
                                  listObj.accountFromName!))
                              .withOpacity(0.35),
                          getColor(getAccountColorFromAccountName(
                                  listObj.accountToName!))
                              .withOpacity(0.35)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ShaderMask(
                        child: Image(
                          image: AssetImage(
                              'assets/icons/other_icons/transfer.png'),
                        ),
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(1.0, 0.0),
                            colors: <Color>[
                              getColor(getAccountColorFromAccountName(
                                      listObj.accountFromName!))
                                  .withOpacity(0.8),
                              getColor(getAccountColorFromAccountName(
                                      listObj.accountToName!))
                                  .withOpacity(0.8)
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${listObj.accountFromName}\t\u{279F}\t${listObj.accountToName}',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    formatDate(listObj.date!, context),
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  trailing: Text(formatCurrency(listObj.amount!)),
                  childrenPadding:
                      EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 5),
                  expandedAlignment: Alignment.topLeft,
                  children: [
                    listObj.description != ''
                        ? Text(
                            '${listObj.description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          )
                        : Text(
                            'no-description'.i18n(),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          )
                  ],
                )
              : SizedBox(),
    );
  }
}
