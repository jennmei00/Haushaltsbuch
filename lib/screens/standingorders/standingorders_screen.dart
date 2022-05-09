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
import 'package:localization/localization.dart';

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
        title: Text('standingorders'.i18n()),
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
          ? NothingThere(textScreen: 'no-standingorder'.i18n())
          : ListView(children: [
              _soWeekly.length == 0
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4.0, top: 6.0, bottom: 4.0, left: 12),
                        child: Text(
                          'weekly'.i18n(),
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
                          'monthly'.i18n(),
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
                          'quarterly'.i18n(),
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
                          'half-yearly'.i18n(),
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
                          'yearly'.i18n(),
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
                  title:  Text("delete-standingorder".i18n()),
                  content:  Text(
                      "delete-standingorder-text".i18n()),
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
                        child:  Text("delete".i18n())),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child:  Text("cancel".i18n()),
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
        child:
            //  item.postingType != PostingType.transfer
            //     ?
            Card(
          child: ExpansionTile(
            leading: item.postingType != PostingType.transfer
                ? Container(
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
                  )
                : Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8,
                            0.0), // 10% of the width, so there are ten blinds.
                        colors: <Color>[
                          getColor(getAccountColorFromAccountName(
                                  item.account!.title!))
                              .withOpacity(0.35),
                          getColor(getAccountColorFromAccountName(
                                  item.accountTo!.title!))
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
                                      item.account!.title!))
                                  .withOpacity(0.8),
                              getColor(getAccountColorFromAccountName(
                                      item.accountTo!.title!))
                                  .withOpacity(0.8)
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                      ),
                    ),
                  ),
            title: item.postingType != PostingType.transfer
                ? Text(item.title!)
                : Text(
                    '${item.account!.title!}\t\u{279F}\t${item.accountTo!.title!}',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
            subtitle: item.postingType != PostingType.transfer
                ? Text(
                    item.account != null ? '${item.account!.title}' : '',
                    style: TextStyle(color: Colors.grey[400]),
                  )
                : Text(''),
            trailing: item.postingType == PostingType.income
                ? Text(
                    '+ ' + formatCurrency(item.amount!),
                    style: TextStyle(color: Colors.green),
                  )
                : item.postingType == PostingType.expense
                    ? Text(
                        '- ' + formatCurrency(item.amount!),
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(
                        formatCurrency(item.amount!),
                      ),
            childrenPadding:
                EdgeInsets.only(left: 20, bottom: 10, right: 10, top: 10),
            expandedAlignment: Alignment.topLeft,
            children: [
              Table(
                children: [
                  if (item.postingType != PostingType.transfer)
                    TableRow(
                      children: [
                        Text("${'category'.i18n()}:"),
                        Text('${item.category!.title}'),
                      ],
                    ),
                  TableRow(
                    children: [
                      Text("${'begin'.i18n()}:"),
                      Text(formatDate(item.begin!, context)),
                    ],
                  ),
                  if (item.end != null)
                    TableRow(
                      children: [
                        Text("${'end'.i18n()}:"),
                        Text(formatDate(item.end!, context)),
                      ],
                    ),
                  TableRow(
                    children: [
                      Text("${'repetition'.i18n()}:"),
                      Text(formatRepetition(item.repetition!)),
                    ],
                  ),
                  if (item.description != '')
                    TableRow(
                      children: [
                        Text("${'description'.i18n()}:"),
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
        ));
  }
}
