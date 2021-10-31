import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class StandingOrdersScreen extends StatefulWidget {
  static final routeName = '/standing_orders_screen';

  @override
  State<StandingOrdersScreen> createState() => _StandingOrdersScreenState();
}

class _StandingOrdersScreenState extends State<StandingOrdersScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Daueraufträge'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddEditStandingOrder.routeName, arguments: '');
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: AllData.standingOrders.length == 0
            ? Text('Keine Daueraufträge vorhanden, erstelle doch welche!')
            :
            // onlongpress -> bearbeitungsmodus
            ListView(
                children: AllData.standingOrders
                    .map((item) => GestureDetector(
                          onLongPress: () {
                            Navigator.of(context).pushNamed(
                                AddEditStandingOrder.routeName,
                                arguments: item.id);
                          },
                          child: Card(
                            child: ExpansionTile(
                              textColor: Colors.black,
                              title: Text(item.title!),
                              subtitle: Text(
                                item.account != null
                                    ? '${item.account!.title}'
                                    : '',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: item.postingType == PostingType.income
                                  ? Text(
                                      '+ ${item.amount!}€',
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : Text(
                                      '- ${item.amount!}€',
                                      style: TextStyle(color: Colors.red),
                                    ),
                              childrenPadding: EdgeInsets.only(
                                  left: 30, bottom: 10, right: 10),
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Kategorie:'),
                                        Text('Beginn:'),
                                        Text('Wiederholung:'),
                                        item.description == ''
                                            ? SizedBox()
                                            : Text('Beschreibung:'),
                                      ],
                                    ),
                                    SizedBox(width: 50),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        item.category != null
                                            ? Text('${item.category!.title}')
                                            : Text(''),
                                        Text(
                                            '${item.begin!.day}.${item.begin!.month}.${item.begin!.year}'),
                                        Text('${item.repetition}'),
                                        item.description == ''
                                            ? SizedBox()
                                            : Text('${item.description}'),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),

                // children: [
                //   GestureDetector(
                //     onLongPress: () {
                //       Navigator.of(context).pushNamed(
                //           AddEditStandingOrder.routeName,
                //           arguments: 'edit');
                //     },
                //     child: Card(
                //       child: ExpansionTile(
                //         title: Text('Versicherung'),
                //         subtitle: Text(
                //           'Kategorie',
                //           style: TextStyle(color: Colors.grey[600]),
                //         ),
                //         trailing: Text(
                //           '- 200,75€',
                //           style: TextStyle(color: Colors.red),
                //         ),
                //         childrenPadding: EdgeInsets.only(
                //             left: 30, bottom: 10, right: 10),
                //         expandedAlignment: Alignment.topLeft,
                //         children: [Text('Beschreibung: ...')],
                //       ),
                //     ),
                //   ),
                //   Card(
                //     child: ListTile(
                //       title: Text('Gehalt'),
                //       subtitle: Text('Kategorie'),
                //       trailing: Text(
                //         '+ 1.500€',
                //         style: TextStyle(color: Colors.green),
                //       ),
                //     ),
                //   ),
                // ],
              ),
      );
}
