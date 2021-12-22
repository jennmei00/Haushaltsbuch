import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class ManagementScreen extends StatefulWidget {
  static final routeName = '/management_screen';

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  // List<Widget> _listViewChildren = [];
  List<Object> _listViewChildren = [];

  void _createListView() {
    _listViewChildren = [];
    _listViewChildren.addAll(AllData.postings);
    _listViewChildren.addAll(AllData.transfers);

    // _listViewChildren.addAll(
    //   AllData.postings.map(
    //     (item) => _listViewWidget(
    //         '${item.id}',
    //         '${item.title}',
    //         Text(
    //           item.account != null ? '${item.account!.title}' : '',
    //           style: TextStyle(color: Colors.grey[600]),
    //         ),
    //         item.postingType == PostingType.income
    //             ? Text(
    //                 '+ ${item.amount!}€',
    //                 style: TextStyle(color: Colors.green),
    //               )
    //             : Text(
    //                 '- ${item.amount!}€',
    //                 style: TextStyle(color: Colors.red),
    //               ),
    //         [
    //           Row(children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text('Kategorie:'),
    //                 Text('Datum/Beginn:'),
    //                 Text('Wiederholung:'),
    //                 item.description == '' ? SizedBox() : Text('Beschreibung:'),
    //               ],
    //             ),
    //             SizedBox(width: 50),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 item.category != null
    //                     ? Text(
    //                         '${item.category!.title}',
    //                         style: TextStyle(color: item.category!.color),
    //                       )
    //                     : Text(''),
    //                 Text('Datum'),
    //                 Text('Wiederholung'),
    //                 // Text(
    //                 //     '${item.begin!.day}.${item.begin!.month}.${item.begin!.year}'),
    //                 // Text('${item.repetition}'),
    //                 item.description == ''
    //                     ? SizedBox()
    //                     : Text('${item.description}'),
    //               ],
    //             )
    //           ])
    //         ]),
    //   ),
    // );
    // _listViewChildren.addAll(AllData.transfers
    //     .map(
    //       (item) => _listViewWidget(
    //         '${item.id}',
    //         '${item.description}',
    //         Text('Umbuchung'),
    //         Text('Trailing'),
    //         [],
    //       ),
    //     )

    //     // Container(
    //     //       child: Card(child: Text('${e.description} TRANSFER')),
    //     //     ))

    //     .toList());

    // _listViewChildren.addAll(AllData.standingOrderPostings
    //     .map(
    //       (item) => _listViewWidget(
    //         '${item.id}',
    //         '${item.standingOrder!.title}',
    //         Text('Daueraufträge'),
    //         Text('Trailing'),
    //         [],
    //       ),
    //     )
    //     // Container(
    //     //       child: Text('${e.standingOrder!.title} STANDINGORDER'),
    //     //     ))
    //     .toList());
  }

  @override
  void initState() {
    _createListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _createListView();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Verwaltung',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.save),
          //   )
          // ],
        ),
        drawer: AppDrawer(),
        body: AllData.accounts.length == 0
            ? NothingThere(textScreen: 'Du hast noch keine Buchung erstellt :(')
            : ListView(
                // children: _listViewChildren,
                children: _listViewChildren.map((e) {
                  return _listViewWidget(e);
                }).toList(),
              ));
  }

  // Widget _listViewWidget(String id, String title, Widget subtitle,
  //     Widget trailing, List<Widget> children) {
  //Posting posting ,Transfer transfer, StandingOrderPosting sop,
  Widget _listViewWidget(Object e) {
    Posting? posting;
    Transfer? transfer;

    if (e is Posting)
      posting = e;
    else if (e is Transfer) transfer = e;

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
      key: ValueKey<String>(
          transfer != null ? transfer.id.toString() : posting!.id.toString()),
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
          child: posting != null
              ? Card(
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
                    childrenPadding:
                        EdgeInsets.only(left: 30, bottom: 10, right: 10),
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      Text('Date'),
                      Text('Description: ${posting.description}'),
                      Text('Category: ${posting.category?.title}'),
                    ],
                  ),
                )
              : Card(
                  child: ExpansionTile(
                    textColor: Colors.black,
                    title: Text(
                        '${transfer?.accountFromName} => ${transfer?.accountToName}'),
                    subtitle: Text('${transfer?.date}'),
                    trailing: Text('${transfer?.amount}'),
                    childrenPadding:
                        EdgeInsets.only(left: 30, bottom: 10, right: 10),
                    expandedAlignment: Alignment.topLeft,
                    children: [
                      Text('No more Data here :('),
                    ],
                  ),
                )),
    );
  }
}
