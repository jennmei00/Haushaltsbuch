import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:path/path.dart';

class ManagePostings extends StatelessWidget {
  final List<Object?> filters;
  final bool search;
  final String searchQuery;

  ManagePostings({
    Key? key,
    this.filters = const [],
    this.search = false,
    this.searchQuery = '',
  }) : super(key: key);

  final List<Posting> _listPosting = [];
  int currentMonthHelper = 0;
  List<Widget> _listofListViewWidgets = [];

  void _loadWithFilter() {
    _listPosting.clear();
    if (filters.length != 0) {
      List<Account> _filterAccounts = filters[0] as List<Account>;
      List<Category> _filterCategories = filters[1] as List<Category>;
      DateTimeRange? _filterDate = filters[2] as DateTimeRange?;
      bool _filterSO = filters[3] as bool;

      AllData.postings.forEach((element) {
        if (_filterAccounts.any((val) => val.id == element.account!.id) ||
            _filterCategories.any((val) => val.id == element.category!.id)) {
          _listPosting.add(element);
        } else if (_filterSO) {
          if (element.description!.contains('Dauerauftrag'))
            _listPosting.add(element);
        } else if (_filterDate != null) {
          if (element.date!.isBefore(_filterDate.end.add(Duration(days: 1))) &&
              (element.date!.isAfter(_filterDate.start) ||
                  element.date! == _filterDate.start)) {
            _listPosting.add(element);
          }
        }
      });
    } else {
      _listPosting.addAll(AllData.postings);
    }
  }

  void _loadWithSearchQuery() {
    _listPosting.clear();
    AllData.postings.forEach((element) {
      if (element.accountName!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          element.amount!.toString().contains(searchQuery.toLowerCase()) ||
          element.category!.title!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          element.description!
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
        _listPosting.add(element);
      }
    });
  }

  void _fillListViewWidgetList(BuildContext context) {
    currentMonthHelper = _listPosting.first.date!.month;
    _listofListViewWidgets.add(
      Card(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 4.0, top: 6.0, bottom: 4.0, left: 12),
          child: Text(
            formatDateMY(_listPosting.first.date!),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        color: Theme.of(context).colorScheme.primaryVariant,
      ),
    );
    for (int i = 0; i < _listPosting.length; i++) {
      //check if month has changed
      if (_listPosting[i].date!.month == currentMonthHelper) {
        _listofListViewWidgets.add(_listViewWidget(_listPosting[i], context));
      } else {
        currentMonthHelper = _listPosting[i].date!.month;
        _listofListViewWidgets.add(
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 4.0, top: 6.0, bottom: 4.0, left: 12),
              child: Text(
                formatDateMY(_listPosting[i].date!),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        );
        _listofListViewWidgets.add(_listViewWidget(_listPosting[i], context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AllData.postings.sort((obj, obj2) => obj2.date!.compareTo(obj.date!));
    if (search) {
      _loadWithSearchQuery();
    } else {
      _loadWithFilter();
    }
    _listofListViewWidgets = [];
    _fillListViewWidgetList(context);

    return AllData.postings.length == 0
        ? NothingThere(textScreen: 'Du hast noch keine Buchung erstellt :(')
        : ListView(
            children: _listofListViewWidgets.map((e) => e).toList(),
          );
  }

  Widget _listViewWidget(Posting posting, BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Buchung löschen"),
                content: const Text(
                    "Bist du sicher, dass du die Buchung löschen willst?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        try {
                          if (posting.account != null) {
                            Account ac = AllData.accounts.firstWhere(
                                (element) => element.id == posting.account!.id);
                            AllData.accounts.remove(ac);
                            if (posting.postingType == PostingType.income)
                              ac.bankBalance =
                                  ac.bankBalance! - posting.amount!;
                            else
                              ac.bankBalance =
                                  ac.bankBalance! + posting.amount!;
                            AllData.accounts.add(ac);
                            await DBHelper.update('Account', ac.toMap(),
                                where: "ID = '${ac.id}'");
                          }

                          AllData.postings.removeWhere(
                              (element) => element.id == posting.id);
                          await DBHelper.delete('Posting',
                              where: "ID = '${posting.id}'");
                        } catch (ex) {
                          //Fehlermeldung ausgeben
                          print(ex);
                        }

                        Navigator.of(context).pop(true);
                      },
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
          Navigator.pushNamed(context, IncomeExpenseScreen.routeName,
              arguments: ['', posting.id]);
          return Future.value(false);
        }
      },
      key: ValueKey<String>(posting.id.toString()),
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
        color: Globals.isDarkmode
            ? Globals.dismissibleEditColorLDark
            : Globals.dismissibleEditColorLight,
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
        color: Globals.isDarkmode
            ? Globals.dismissibleDeleteColorDark
            : Globals.dismissibleDeleteColorLight,
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
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: getColor(posting.category!.color!).withOpacity(0.20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    posting.category!.symbol!,
                    color: getColor(posting.category!.color!),
                  ),
                ),
              ),
              // leading: CircleAvatar(
              //   backgroundColor: Colors.transparent,
              //   child: FractionallySizedBox(
              //     widthFactor: 0.6,
              //     heightFactor: 0.6,
              //     child: Image.asset(
              //       posting.category!.symbol!,
              //       color: getColor(posting.category!.color!),
              //     ),
              //   ),
              // ),
              title: Text('${posting.title}'),
              subtitle: Text(
                '${posting.accountName}',
                style: TextStyle(color: Colors.grey.shade400),
              ),
              trailing: posting.postingType == PostingType.income
                  ? Text(
                      '+ ' + formatCurrency(posting.amount!),
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      '- ' + formatCurrency(posting.amount!),
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
                        Text('${posting.category!.title}'),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Datum:'),
                        Text(formatDate(posting.date!)),
                      ],
                    ),
                    if (posting.description != '')
                      TableRow(
                        children: [
                          Text('Beschreibung:'),
                          Text(
                            '${posting.description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            softWrap: false,
                          ),
                        ],
                      )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
