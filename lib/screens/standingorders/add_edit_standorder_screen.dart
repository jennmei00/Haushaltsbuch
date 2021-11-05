import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/standing_order_posting.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class AddEditStandingOrder extends StatefulWidget {
  static final routeName = '/edit_standingorder_screen';

  final String id;

  AddEditStandingOrder({this.id = ''});

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

  late List<ListItem> _accountDropDownItems;
  late ListItem _selectedItem;

  void _getAccountDropDownItems() {
    _selectedItem = ListItem('', '');

    _accountDropDownItems = [ListItem('', '')];
    if (AllData.accounts.length != 0) {
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      _selectedItem = _accountDropDownItems.first;

      setState(() {});
    }
  }

  void _getStandingOrderData() {
    StandingOrder so =
        AllData.standingOrders.firstWhere((element) => element.id == widget.id);
    // _repeatValue = Repetition.values(so.repetition!.index);
    _groupValue_buchungsart = so.postingType!.index;
    _dateTime = so.begin!;
    _selectedItem = _accountDropDownItems
        .firstWhere((element) => element.value == so.account!.id);
    //Category
    _amountController.text = so.amount!.toString();
    _titleController.text = so.title!;
    _descriptionController.text = so.description!;
  }

  @override
  void initState() {
    _getAccountDropDownItems();
    if (widget.id != '') {
      _getStandingOrderData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == ''
            ? 'Dauerauftrag hinzufügen'
            : 'Dauerauftrag bearbeiten'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_titleController.text != '' &&
                  _descriptionController.text != '' &&
                  isNumeric(_amountController.text))
              //If Category is selected
              //description kein muss!
              {
                StandingOrder so = StandingOrder(
                  id: widget.id != '' ? widget.id : Uuid().v1(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  account: AllData.accounts.firstWhere(
                      (element) => element.id == _selectedItem.value),
                  // category: , //Kategorie auswahl
                  begin: _dateTime,
                  postingType: PostingType.values[_groupValue_buchungsart],
                  // repetition: Repetition.values[], //Repetitionvalue abfragen
                );

                StandingOrderPosting sop = StandingOrderPosting(
                    id: Uuid().v1(), date: _dateTime, standingOrder: so);

                if (widget.id == '') {
                  await DBHelper.insert('Standingorder', so.toMap());
                  await DBHelper.insert('StandingorderPosting', sop.toMap());
                } else {
                  await DBHelper.update('Standingorder', so.toMap(),
                      where: "ID = '${so.id}'");
                  await DBHelper.update('StandingorderPosting', sop.toMap(),
                      where: "ID = '${so.id}'");

                  AllData.standingOrders
                      .removeWhere((element) => element.id == so.id);
                  AllData.standingOrderPostings
                      .removeWhere((element) => element.id == sop.id);
                }
                AllData.standingOrders.add(so);
                AllData.standingOrderPostings.add(sop);

                Navigator.popAndPushNamed(
                    context, StandingOrdersScreen.routeName);
              } else
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter some text in the TextFields.'),
                ));

              // ignore: todo
              //TODO: Testen ob Eintrag in StandingorderPosting funktioniert
              // Kontrollieren, ob Erstell- oder Bearbeitungsmodus
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text('Konto auswählen:'),
              SizedBox(height: 10),
              DropDown(
                dropdownItems: _accountDropDownItems,
                listItemValue: _selectedItem.value,
                onChanged: (newValue) {
                  _selectedItem = newValue as ListItem;
                  setState(() {});
                },
              ),
              SizedBox(height: 20),
              Text('Kategorie auswählen:'),
              SizedBox(height: 10),
              Container(
                height: 100,
                // padding: EdgeInsets.all(20),
                // color: Colors.grey[400]?.withOpacity(0.5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: AllData.categires
                          .map((item) => new CircleAvatar(
                                radius: 40,
                                backgroundColor: item.color,
                                child: Text('${item.title}'),
                              ))
                          .toList(),
                    ),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                    Text('data'),
                  ]),
                ),
              ),
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
            ]),
            saveButton: true,
            cancelButton: true,
          );
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
