import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

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

  @override
  Widget build(BuildContext context) {
    if (search) {
      _loadWithSearchQuery();
    } else {
      _loadWithFilter();
    }

    AllData.postings.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));

    return AllData.postings.length == 0
        ? NothingThere(textScreen: 'Du hast noch keine Buchung erstellt :(')
        : ListView(
            children: _listPosting.map((Posting e) {
              return _listViewWidget(e, context);
            }).toList(),
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
                    "Bist du sicher, dass die Buchung löschen willst?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
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
          print('In Bearbeitungsmodus springen');
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
        color: Colors.orange,
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
        color: Colors.red,
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
              textColor: Colors.black,
              title: Text('${posting.title}'),
              subtitle: Text('${posting.accountName}'),
              trailing: posting.postingType == PostingType.income
                  ? Text(
                      '+ ${posting.amount!}€',
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      '- ${posting.amount!}€',
                      style: TextStyle(color: Colors.red),
                    ),
              childrenPadding: EdgeInsets.only(left: 30, bottom: 10, right: 10),
              expandedAlignment: Alignment.topLeft,
              children: [
                Text('Date: ${posting.date}'),
                Text('Description: ${posting.description}'),
                Text('Category: ${posting.category?.title}'),
              ],
            ),
          )),
    );
  }
}
