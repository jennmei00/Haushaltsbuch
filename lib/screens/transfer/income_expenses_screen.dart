import 'package:flutter/material.dart';

class IncomeExpenseScreen extends StatefulWidget {
  static final routeName = '/income_expense_screen';
  final String type;

  IncomeExpenseScreen({this.type = ''});

  @override
  _IncomeExpenseScreenState createState() => _IncomeExpenseScreenState();
}

class _IncomeExpenseScreenState extends State<IncomeExpenseScreen> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type}'),
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
                  Text('Tag der ${widget.type}:'),
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
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Kategorie',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: '',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
              ExpansionTile(
                title: Text('Dauerauftrag'),
                
                onExpansionChanged: (value) {
                  print(value);
                },
                // trailing: Switch(value: false, onChanged: (value) {}),
              )
              // SwitchListTile(
              //   value: false,
              //   title: Text('Dauerauftrag'),
              //   onChanged: (value) {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
