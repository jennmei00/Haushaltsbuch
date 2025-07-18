import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:localization/localization.dart';

class ManageTransfers extends StatefulWidget {
  final List<Object?> filters;
  final bool search;
  final String searchQuery;

  ManageTransfers({
    Key? key,
    this.filters = const [],
    this.search = false,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  State<ManageTransfers> createState() => _ManageTransfersState();
}

class _ManageTransfersState extends State<ManageTransfers> {
  final List<Transfer> _listTransfer = [];

  int currentMonthHelper = 0;

  int currentYearHelper = 0;

  List<Widget> _listofListViewWidgets = [];

  void _loadWithFilter() {
    _listTransfer.clear();
    if (widget.filters.length != 0) {
      List<Account> _filterAccounts = widget.filters[0] as List<Account>;
      DateTimeRange? _filterDate = widget.filters[2] as DateTimeRange?;

      AllData.transfers.forEach((element) {
        if ((_filterAccounts.length == 0
                ? true
                : (element.accountFrom == null
                        ? false
                        : _filterAccounts
                            .any((val) => val.id == element.accountFrom!.id)) ||
                    (element.accountTo == null
                        ? false
                        : _filterAccounts
                            .any((val) => val.id == element.accountTo!.id))) &&
            (_filterDate == null
                ? true
                : (element.date!
                        .isBefore(_filterDate.end.add(Duration(days: 1))) &&
                    (element.date!.isAfter(_filterDate.start) ||
                        element.date! == _filterDate.start)))) {
          _listTransfer.add(element);
        }
      });
    } else {
      _listTransfer.addAll(AllData.transfers);
    }
  }

  void _loadWithSearchQuery() {
    _listTransfer.clear();
    AllData.transfers.forEach((element) {
      if (element.accountFromName!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.accountToName!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.amount!
              .toString()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.description!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase())) {
        _listTransfer.add(element);
      }
    });
  }

  void _fillListViewWidgetList(BuildContext context) {
    currentMonthHelper = _listTransfer.first.date!.month;
    currentYearHelper = _listTransfer.first.date!.year;
    _listofListViewWidgets.add(
      Card(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 4.0, top: 6.0, bottom: 4.0, left: 12),
          child: Text(
            formatDateMY(_listTransfer.first.date!, context),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        color: Theme.of(context).primaryColorDark,
      ),
    );
    for (int i = 0; i < _listTransfer.length; i++) {
      //check if month has changed
      if (_listTransfer[i].date!.month != currentMonthHelper ||
          _listTransfer[i].date!.year != currentYearHelper) {
        currentMonthHelper = _listTransfer[i].date!.month;
        currentYearHelper = _listTransfer[i].date!.year;
        _listofListViewWidgets.add(
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 4.0, top: 6.0, bottom: 4.0, left: 12),
              child: Text(
                formatDateMY(_listTransfer[i].date!, context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            color: Theme.of(context).primaryColorDark,
          ),
        );
        _listofListViewWidgets.add(_listViewWidget(_listTransfer[i], context));
      } else {
        _listofListViewWidgets.add(_listViewWidget(_listTransfer[i], context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AllData.transfers.sort((obj, obj2) => obj2.date!.compareTo(obj.date!));

    if (widget.search) {
      _loadWithSearchQuery();
    } else {
      _loadWithFilter();
    }
    _listofListViewWidgets = [];
    if (_listTransfer.length != 0) {
      _fillListViewWidgetList(context);
    }

    return AllData.transfers.length == 0
        ? NothingThere(textScreen: 'no-transfers'.i18n())
        : ListView(
            children: _listofListViewWidgets.map((e) => e).toList(),
          );
  }

  Widget _listViewWidget(Transfer transfer, BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("delete-transfer".i18n()),
                content: Text("delete-transfer-text".i18n()),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => _deleteTransfer(context, transfer),
                      child: Text("delete".i18n())),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("cancel".i18n()),
                  ),
                ],
              );
            },
          );
        } else {
          var saved = await Navigator.pushNamed(
              context, TransferScreen.routeName,
              arguments: transfer.id);

          if (saved == true) setState(() {});

          return Future.value(false);
        }
      },
      key: ValueKey<String>(transfer.id.toString()),
      onDismissed: (DismissDirection direction) {},
      direction: DismissDirection.horizontal,
      background: Container(
        color: Globals.isDarkmode
            ? Globals.dismissibleEditColorLDark
            : Globals.dismissibleEditColorLight,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.edit, color: Colors.white),
              Text('edit'.i18n(), style: TextStyle(color: Colors.white)),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete, color: Colors.white),
              Text('delete'.i18n(), style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: Card(
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(
                    0.8, 0.0), // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  getColor(getAccountColorFromAccountName(
                          transfer.accountFromName!))
                      .withValues(alpha: 0.35),
                  getColor(getAccountColorFromAccountName(
                          transfer.accountToName!))
                      .withValues(alpha: 0.35)
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ShaderMask(
                child: Image(
                  image: AssetImage('assets/icons/other_icons/transfer.png'),
                ),
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(1.0, 0.0),
                    colors: <Color>[
                      getColor(getAccountColorFromAccountName(
                              transfer.accountFromName!))
                          .withValues(alpha: 0.8),
                      getColor(getAccountColorFromAccountName(
                              transfer.accountToName!))
                          .withValues(alpha: 0.8)
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
                  '${transfer.accountFromName}\t\u{279F}\t${transfer.accountToName}',
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
          subtitle: Text(
            formatDate(transfer.date!, context),
            style: TextStyle(color: Colors.grey.shade400),
          ),
          trailing: Text(formatCurrency(transfer.amount!,locale: Localizations.localeOf(context).languageCode)),
          childrenPadding:
              EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 5),
          expandedAlignment: Alignment.topLeft,
          children: [
            transfer.description != ''
                ? Text(
                    '${transfer.description}',
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
        ),
      ),
    );
  }

  void _deleteTransfer(BuildContext context, Transfer transfer) async {
    try {
      Account? acFrom = transfer.accountFrom == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == transfer.accountFrom!.id);
      Account? acTo = transfer.accountTo == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == transfer.accountTo!.id);
      if (acFrom != null) {
        AllData.accounts.removeWhere((element) => element.id == acFrom.id);
        acFrom.bankBalance = acFrom.bankBalance! + transfer.amount!;
        await DBHelper.update('Account', acFrom.toMap(),
            where: "ID = '${acFrom.id}'");
        AllData.accounts.add(acFrom);
      }
      if (acTo != null) {
        AllData.accounts.removeWhere((element) => element.id == acTo.id);
        acTo.bankBalance = acTo.bankBalance! - transfer.amount!;
        await DBHelper.update('Account', acTo.toMap(),
            where: "ID = '${acTo.id}'");
        AllData.accounts.add(acTo);
      }

      AllData.transfers.removeWhere((element) => element.id == transfer.id);
      DBHelper.delete('Transfer', where: "ID = '${transfer.id}'");
    } catch (ex) {
      print('Manage Transfers $ex');
    }

    Navigator.of(context).pop(true);
    this.setState(() {});
  }
}
