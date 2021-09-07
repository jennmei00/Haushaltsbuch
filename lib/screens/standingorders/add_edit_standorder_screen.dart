import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

class AddEditStandingOrder extends StatefulWidget {
  static final routeName = '/edit_standingorder_screen';

  final String type;

  AddEditStandingOrder({this.type = ''});

  @override
  _AddEditStandingOrderState createState() => _AddEditStandingOrderState();
}

class _AddEditStandingOrderState extends State<AddEditStandingOrder> {
  DateTime _dateTime = DateTime.now();
  String _repeatValue = 'monatlich';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'add'
            ? 'Dauerauftrag hinzufügen'
            : 'Dauerauftrag bearbeiten'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Beginn:'),
                  Row(
                    children: [
                      Text(
                          '${_dateTime.day}. ${_dateTime.month}. ${_dateTime.year}'),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: _dateTime,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          ).then((value) => setState(() => _dateTime = value!));
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Wiederholung'),
                  TextButton(
                    onPressed: () => _repeatStandingorder(),
                    child: Text('$_repeatValue'),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text('Tag der ${widget.type}:'),
                  Row(
                    children: [
                      // Text(
                      //     '${_incomeDateTime.day}. ${_incomeDateTime.month}. ${_incomeDateTime.year}'),
                      // IconButton(
                      //   icon: Icon(Icons.date_range),
                      //   onPressed: () {
                      //     showDatePicker(
                      //       context: context,
                      //       initialDate: _incomeDateTime,
                      //       firstDate:
                      //           DateTime.now().subtract(Duration(days: 365)),
                      //       lastDate: DateTime.now().add(Duration(days: 365)),
                      //     ).then((value) =>
                      //         setState(() => _incomeDateTime = value!));
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Konto',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: 'Kontoname',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(height: 20),
              Text('Kategorie - DorpDown noch in arbeit'),
              // TextField(
              //   decoration: InputDecoration(
              //       labelText: 'Kategorie',
              //       labelStyle: TextStyle(fontSize: 20),
              //       hintText: '',
              //       filled: true,
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(),
              //         borderRadius: BorderRadius.circular(30),
              //       )),
              // ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Betrag',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: 'in €',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Bezeichnung',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: '',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Beschreibung',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: '',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _repeatStandingorder() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
              'Wiederholung',
              Column(children: [
                TextButton(
                  onPressed: () => _repeatValuePressed(0),
                  child: Text('wöchentlich'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _repeatValuePressed(1),
                  child: Text('monatlich'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _repeatValuePressed(2),
                  child: Text('jährlich'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
              ]));
        });
  }

  void _repeatValuePressed(int value) {
    switch (value) {
      case 0:
        _repeatValue = 'wöchentlich';
        break;
      case 1:
        _repeatValue = 'monatlich';
        break;
      case 2:
        _repeatValue = 'jährlich';
        break;
      default:
        return;
    }
    this.setState(() {});
    Navigator.pop(context, true);
  }
}
