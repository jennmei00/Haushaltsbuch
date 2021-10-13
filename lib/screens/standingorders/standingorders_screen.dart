import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/screens/standingorders/add_edit_standorder_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class StandingOrdersScreen extends StatefulWidget {
  static final routeName = '/standing_orders_screen';

  @override
  State<StandingOrdersScreen> createState() => _StandingOrdersScreenState();
}

class _StandingOrdersScreenState extends State<StandingOrdersScreen> {
  List<StandingOrder> _soList = [];
  bool _isLoading = true;

  Future<void> _getStandingorderList() async {
    _soList =
        StandingOrder().listFromDB(await DBHelper.getData('Standingorder'));
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    _getStandingorderList();
    super.initState();
  }

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
                .pushNamed(AddEditStandingOrder.routeName, arguments: 'add');
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _soList.length == 0
                ? Text('Keine Daueraufträge vorhanden, erstelle doch welche!')
                : 
                //TODO: Liste der Daten anpassen (aus _soList)
                ListView(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          Navigator.of(context).pushNamed(
                              AddEditStandingOrder.routeName,
                              arguments: 'edit');
                        },
                        child: Card(
                          child: ExpansionTile(
                            title: Text('Versicherung'),
                            subtitle: Text(
                              'Kategorie',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              '- 200,75€',
                              style: TextStyle(color: Colors.red),
                            ),
                            childrenPadding: EdgeInsets.only(
                                left: 30, bottom: 10, right: 10),
                            expandedAlignment: Alignment.topLeft,
                            children: [Text('Beschreibung: ...')],
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Gehalt'),
                          subtitle: Text('Kategorie'),
                          trailing: Text(
                            '+ 1.500€',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
      );
}
