import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class ManageTransfers extends StatelessWidget {
  final List<Object?> filters;
  final bool search;
  final String searchQuery;

  ManageTransfers({
    Key? key,
    this.filters = const [],
    this.search = false,
    this.searchQuery = '',
  }) : super(key: key);

  final List<Transfer> _listTransfer = [];

  void _loadWithFilter() {
    _listTransfer.clear();
    if (filters.length != 0) {
      List<Account> _filterAccounts = filters[0] as List<Account>;
      DateTimeRange? _filterDate = filters[2] as DateTimeRange?;

      AllData.transfers.forEach((element) {
        if (_filterAccounts.any((val) => val.id == element.accountFrom!.id) ||
            _filterAccounts.any((val) => val.id == element.accountTo!.id)) {
          _listTransfer.add(element);
        } else if (_filterDate != null) {
          if (element.date!.isBefore(_filterDate.end.add(Duration(days: 1))) &&
              (element.date!.isAfter(_filterDate.start) ||
                  element.date! == _filterDate.start)) {
            _listTransfer.add(element);
          }
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
              .contains(searchQuery.toLowerCase()) ||
          element.accountToName!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          element.amount!.toString().contains(searchQuery.toLowerCase()) ||
          element.description!
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
        _listTransfer.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AllData.transfers.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));

    if (search) {
      _loadWithSearchQuery();
    } else {
      _loadWithFilter();
    }

    return AllData.transfers.length == 0
        ? NothingThere(textScreen: 'Du hast noch keine Umbuchung erstellt :(')
        : ListView(
            children: _listTransfer.map((Transfer e) {
              return _listViewWidget(e, context);
            }).toList(),
          );
  }

  Widget _listViewWidget(Transfer transfer, BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Buchung löschen"),
                content: const Text(
                    "Bist du sicher, dass die Buchung löschen willst?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => _deleteTransfer(context, transfer),
                      child: const Text("Löschen")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Abbrechen"),
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pushNamed(context, TransferScreen.routeName,
              arguments: transfer.id);
          return Future.value(false);
        }
      },
      key: ValueKey<String>(transfer.id.toString()),
      onDismissed: (DismissDirection direction) {
        // AllData.standingOrders.remove(item);
        // DBHelper.delete('StandingOrder',
        //     where: "ID = '${item.id}'");

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Dauerauftrag wurde gelöscht')));
        // setState(() {});
      },
      direction: DismissDirection.horizontal,
      background: Container(
        color: Globals.isDarkmode ? Globals.dismissibleEditColorLDark : Globals.dismissibleEditColorLight,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.edit, color: Colors.white),
              Text('Edit', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Globals.isDarkmode ? Globals.dismissibleDeleteColorDark : Globals.dismissibleDeleteColorLight,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete, color: Colors.white),
              Text('Move to trash', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: GestureDetector(
        onLongPress: () {
          // Navigator.of(context).pushNamed(
          //     AddEditStandingOrder.routeName,
          //     arguments: item.id);
        },
        child: Card(
          child: ExpansionTile(
            title: Row(
              children: [
                Text('${transfer.accountFromName}  '),
                Icon(Icons.arrow_right_alt),
                Text('  ${transfer.accountToName}'),
              ],
            ),
            subtitle: Text(
              formatDate(transfer.date!),
              style: TextStyle(color: Colors.grey.shade400),
            ),
            trailing: Text(formatCurrency(transfer.amount!)),
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
                      'Keine Beschreibung...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    )
            ],
          ),
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
      print(ex);
    }

    Navigator.of(context).pop(true);
  }
}
