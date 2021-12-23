import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class ManageTransfers extends StatelessWidget {
  const ManageTransfers({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return AllData.postings.length == 0
        ? NothingThere(textScreen: 'Du hast noch keine Buchung erstellt :(')
        : ListView(
            // children: _listViewChildren,
            children: AllData.transfers.map((Transfer e) {
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
            title: Text(
                '${transfer.accountFromName} => ${transfer.accountToName}'),
            subtitle: Text('${transfer.date}'),
            trailing: Text('${transfer.amount}'),
            childrenPadding: EdgeInsets.only(left: 30, bottom: 10, right: 10),
            expandedAlignment: Alignment.topLeft,
            children: [
              Text('No more Data here :('),
            ],
          ),
        ),
      ),
    );
  }
}
