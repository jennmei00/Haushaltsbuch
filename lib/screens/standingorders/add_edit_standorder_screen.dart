import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:uuid/uuid.dart';

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
  // ignore: non_constant_identifier_names
  int _groupValue_buchungsart = 0;
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');

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
            onPressed: () async {
              StandingOrder so = StandingOrder(
                id: Uuid().v1(),
                title: _titleController.text,
                description: _descriptionController.text,
                amount: double.parse(_amountController.text),
                // account: , //Konto auswahl
                // category: , //Kategorie auswahl
                begin: _dateTime,
                postingType: PostingType.values[_groupValue_buchungsart],
                // repetition: Repetition.values[], //Repetitionvalue abfragen
              );

              DBHelper.insert('Standingorder', so.toMap());

              // ignore: todo
              //TODO: Testen ob Eintrag in StandingorderPosting funktioniert
              // Kontrollieren, ob Erstell- oder Bearbeitungsmodus

              // StandingOrderPosting sop = StandingOrderPosting(
              //     id: Uuid().v1(), date: _dateTime, standingOrder: so);
              // DBHelper.insert('StandingorderPosting', sop.toMap());

              Navigator.pop(context);
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
              FractionallySizedBox(
                widthFactor: 0.9,
                child: CupertinoSlidingSegmentedControl(
                  children: <Object, Widget>{
                    0: Text('Einnahme'),
                    1: Text('Ausgabe')
                  },
                  onValueChanged: (val) {
                    setState(() {
                      _groupValue_buchungsart = val as int;
                    });
                  },
                  groupValue: _groupValue_buchungsart,
                ),
              ),
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
              // ignore: todo
              //TODO: Konto als DropDown
              Text('Kontoauswahl als DropDown'),
              // CustomTextField(
              //   labelText: 'Konto',
              //   hintText: 'Kontoname',
              // ),
              SizedBox(height: 20),
              // ignore: todo
              //TODO: Kategorie als PopUp bzw. Seite
              Text('Kategorie - PopUp/Seite noch in arbeit'),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Betrag',
                hintText: 'in €',
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Bezeichnung',
                hintText: '',
                controller: _titleController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Beschreibung',
                hintText: '',
                controller: _descriptionController,
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
              title: 'Wiederholung',
              body: Column(children: [
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
              ]),saveButton: true, cancelButton: true,);
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
