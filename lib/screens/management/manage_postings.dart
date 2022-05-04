import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:localization/localization.dart';

class ManagePostings extends StatefulWidget {
  final List<Object?> filters;
  final bool search;
  final String searchQuery;

  ManagePostings({
    Key? key,
    this.filters = const [],
    this.search = false,
    this.searchQuery = '',
  }) : super(key: key);

  @override
  State<ManagePostings> createState() => _ManagePostingsState();
}

class _ManagePostingsState extends State<ManagePostings> {
  final List<Posting> _listPosting = [];

  int currentMonthHelper = 0;

  int currentYearHelper = 0;

  List<Widget> _listofListViewWidgets = [];

  void _loadWithFilter() {
    _listPosting.clear();
    if (widget.filters.length != 0) {
      List<Account> _filterAccounts = widget.filters[0] as List<Account>;
      List<Category> _filterCategories = widget.filters[1] as List<Category>;
      DateTimeRange? _filterDate = widget.filters[2] as DateTimeRange?;
      bool _filterSO = widget.filters[3] as bool;

      AllData.postings.forEach((element) {
        if ((_filterAccounts.length == 0
                ? true
                : _filterAccounts
                    .any((val) => val.id == element.account!.id)) &&
            (_filterCategories.length == 0
                ? true
                : _filterCategories
                    .any((val) => val.id == element.category!.id)) &&
            (_filterSO ? element.isStandingOrder! : true) &&
            (_filterDate == null
                ? true
                : (element.date!
                        .isBefore(_filterDate.end.add(Duration(days: 1))) &&
                    (element.date!.isAfter(_filterDate.start) ||
                        element.date! == _filterDate.start)))) {
          _listPosting.add(element);
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
              .contains(widget.searchQuery.toLowerCase()) ||
          element.title!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.amount!
              .toString()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.category!.title!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          element.description!
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase())) {
        _listPosting.add(element);
      }
    });
  }

  void _fillListViewWidgetList(BuildContext context) {
    currentMonthHelper = _listPosting.first.date!.month;
    currentYearHelper = _listPosting.first.date!.year;
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
          color: Theme.of(context).primaryColorDark),
    );
    for (int i = 0; i < _listPosting.length; i++) {
      //check if month has changed
      if (_listPosting[i].date!.month != currentMonthHelper ||
          _listPosting[i].date!.year != currentYearHelper) {
        currentMonthHelper = _listPosting[i].date!.month;
        currentYearHelper = _listPosting[i].date!.year;
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
            color: Theme.of(context).primaryColorDark,
          ),
        );
        _listofListViewWidgets.add(_listViewWidget(_listPosting[i], context));
      } else {
        _listofListViewWidgets.add(_listViewWidget(_listPosting[i], context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AllData.postings.sort((obj, obj2) => obj2.date!.compareTo(obj.date!));
    if (widget.search) {
      _loadWithSearchQuery();
    } else {
      _loadWithFilter();
    }
    _listofListViewWidgets = [];
    if (_listPosting.length != 0) {
      _fillListViewWidgetList(context);
    }

    return AllData.postings.length == 0
        ? NothingThere(textScreen: 'no-postings'.i18n())
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
                  title:  Text("delete-posting".i18n()),
                  content:  Text(
                      "delete-posting-text".i18n()),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          try {
                            if (posting.account != null) {
                              Account ac = AllData.accounts.firstWhere(
                                  (element) =>
                                      element.id == posting.account!.id);
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
                            print(ex);
                            FileHelper().writeAppLog(
                                AppLog(ex.toString(), 'Delete Posting'));
                          }

                          Navigator.of(context).pop(true);
                          this.setState(() {});
                        },
                        child:  Text("delete".i18n())),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child:  Text("cancel".i18n()),
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
                      Text("${'category'.i18n()}:"),
                      Text('${posting.category!.title}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text("${'date'.i18n()}:"),
                      Text(formatDate(posting.date!)),
                    ],
                  ),
                  if (posting.description != '')
                    TableRow(
                      children: [
                        Text("${'description'.i18n()}:"),
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
        ));
  }
}
