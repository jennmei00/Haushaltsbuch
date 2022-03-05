import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class StandingOrdersScreen extends StatefulWidget {
  static final routeName = '/standing_orders_screen';

  @override
  State<StandingOrdersScreen> createState() => _StandingOrdersScreenState();
}

class _StandingOrdersScreenState extends State<StandingOrdersScreen> {
  List<StandingOrder> _soWeekly = [];
  List<StandingOrder> _soMonthly = [];
  List<StandingOrder> _soYearly = [];
  List<StandingOrder> _soQuarterly = [];
  List<StandingOrder> _soHalfYearly = [];

  void _sortStandingorder() {
    _soWeekly.addAll(AllData.standingOrders
        .where((element) => element.repetition == Repetition.weekly)
        .toList());
    _soWeekly.sort((obj, obj2) => obj.begin!.compareTo(obj2.begin!));

    _soMonthly.addAll(AllData.standingOrders
        .where((element) => element.repetition == Repetition.monthly)
        .toList());
    _soMonthly.sort((obj, obj2) => obj.begin!.compareTo(obj2.begin!));

    _soYearly.addAll(AllData.standingOrders
        .where((element) => element.repetition == Repetition.yearly)
        .toList());
    _soYearly.sort((obj, obj2) => obj.begin!.compareTo(obj2.begin!));

    _soQuarterly.addAll(AllData.standingOrders
        .where((element) => element.repetition == Repetition.quarterly)
        .toList());
    _soQuarterly.sort((obj, obj2) => obj.begin!.compareTo(obj2.begin!));

    _soHalfYearly.addAll(AllData.standingOrders
        .where((element) => element.repetition == Repetition.halfYearly)
        .toList());
    _soHalfYearly.sort((obj, obj2) => obj.begin!.compareTo(obj2.begin!));
  }

  @override
  void initState() {
    _sortStandingorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daueraufträge'),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        selectedMenuItem: 'standingorders',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddEditStandingOrder.routeName, arguments: '');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: AllData.standingOrders.length == 0
          ? NothingThere(textScreen: 'Noch keine Daueraufträge vorhanden :(')
          : ListView(children: [
              _soWeekly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'Wöchentlich',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      color: Theme.of(context).primaryColorDark,
                    ),
              Column(children: _soWeekly.map((e) => _soCard(e)).toList()),
              _soMonthly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'Monatlich',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      color: Theme.of(context).primaryColorDark,
                    ),
              Column(children: _soMonthly.map((e) => _soCard(e)).toList()),
              _soQuarterly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'Vierteljährlich',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      color: Theme.of(context).primaryColorDark,
                    ),
              Column(children: _soQuarterly.map((e) => _soCard(e)).toList()),
              _soHalfYearly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'Halbjährlich',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      color: Theme.of(context).primaryColorDark,
                    ),
              Column(children: _soHalfYearly.map((e) => _soCard(e)).toList()),
              _soYearly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'Jährlich',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      color: Theme.of(context).primaryColorDark,
                    ),
              Column(children: _soYearly.map((e) => _soCard(e)).toList()),
            ]),
    );
  }

  Dismissible _soCard(StandingOrder item) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          Navigator.of(context)
              .pushNamed(AddEditStandingOrder.routeName, arguments: item.id);
          return Future.value(false);
        } else {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Dauerauftrag löschen"),
                content: const Text(
                    "Bist du sicher, dass du den Dauerauftrag löschen willst?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        AllData.standingOrders
                            .removeWhere((element) => element.id == item.id);

                        AllData.postings
                            .where((element) => element.standingOrder == null
                                ? false
                                : element.standingOrder?.id == element.id)
                            .forEach((posting) async {
                          posting.standingOrder = null;
                          await DBHelper.update('Posting', posting.toMap(),
                              where: "ID = '${posting.id}'");
                          AllData
                              .postings[AllData.postings
                                  .indexWhere((e) => e.id == posting.id)]
                              .standingOrder = null;
                        });

                        await DBHelper.delete('StandingOrder',
                            where: "ID = '${item.id}'");
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
        }
      },
      key: ValueKey<String>(item.id.toString()),
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
      child: Card(
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: getColor(item.category!.color!).withOpacity(0.20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                item.category!.symbol!,
                color: getColor(item.category!.color!),
              ),
            ),
          ),
          title: Text(item.title!),
          subtitle: Text(
            item.account != null ? '${item.account!.title}' : '',
            style: TextStyle(color: Colors.grey[400]),
          ),
          trailing: item.postingType == PostingType.income
              ? Text(
                  '+ ' + formatCurrency(item.amount!),
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  '- ' + formatCurrency(item.amount!),
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
                    Text('${item.category!.title}'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Beginn:'),
                    Text(formatDate(item.begin!)),
                  ],
                ),
                if (item.end != null)
                  TableRow(
                    children: [
                      Text('Ende:'),
                      Text(formatDate(item.end!)),
                    ],
                  ),
                TableRow(
                  children: [
                    Text('Wiederholung:'),
                    Text(formatRepetition(item.repetition!)),
                  ],
                ),
                if (item.description != '')
                  TableRow(
                    children: [
                      Text('Beschreibung:'),
                      Text(
                        '${item.description}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                      ),
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
