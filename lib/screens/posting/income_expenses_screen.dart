import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class IncomeExpenseScreen extends StatefulWidget {
  static final routeName = '/income_expense_screen';
  final String type;

  IncomeExpenseScreen({this.type = ''});

  @override
  _IncomeExpenseScreenState createState() => _IncomeExpenseScreenState();
}

class _IncomeExpenseScreenState extends State<IncomeExpenseScreen> {
  DateTime _incomeDateTime = DateTime.now();
  // DateTime _beginSO = DateTime.now();
  // bool _standingorderSwitch = false;
  // String _repeatValue = 'monatlich';
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  List<ListItem> _accountDropDownItems = [
    // ListItem('0', 'name'),
    // ListItem('1', ' ')
  ];
  late ListItem _selectedItem;
  String _selectedCategoryID = '';

  void _getAccountDropDownItems() {
    _selectedItem = ListItem('0', 'name');
    if (AllData.accounts.length != 0) {
      _accountDropDownItems = [];
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      _selectedItem = _accountDropDownItems.first;
      setState(() {});
    }
  }

  @override
  void initState() {
    _getAccountDropDownItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type}'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_titleController.text != '' &&
                    isFloat(_amountController.text))
                //If Category is selected
                {
                  Posting posting = Posting(
                    id: Uuid().v1(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    account: AllData.accounts.firstWhere((element) =>
                        element.id == _selectedItem.id), //Ausgewähltes Konto
                    amount: double.parse(_amountController.text),
                    // category: , //Ausgewählte Kategorie
                    date: _incomeDateTime,
                    postingType: widget.type == 'Einnahme'
                        ? PostingType.income
                        : PostingType.expense,
                    category: AllData.categories.firstWhere((element) =>
                        element.id ==
                        _selectedCategoryID), //Ausgewählte Kategorie
                  );
                  DBHelper.insert('Posting', posting.toMap()).then((value) =>
                      Navigator.popAndPushNamed(
                          context, PostingScreen.routeName));
                  AllData.postings.add(posting);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Das Speichern in die Datenbank ist \n schiefgelaufen :(',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Ups, da passt etwas noch nicht :(',
                    textAlign: TextAlign.center,
                  ),
                ));
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tag der ${widget.type}:'),
                Row(
                  children: [
                    Text(
                        '${_incomeDateTime.day}. ${_incomeDateTime.month}. ${_incomeDateTime.year}'),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _incomeDateTime,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        ).then((value) =>
                            setState(() => _incomeDateTime = value!));
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Text('Konto wählen:'),
            // SizedBox(height: 10),
            DropDown(
              dropdownItems: _accountDropDownItems,
              onChanged: (newValue) {
                _selectedItem = newValue as ListItem;
                setState(() {});
              },
              listItemValue: _selectedItem.id,
              dropdownHintText: 'Konto',
            ),
            SizedBox(height: 20),
            Text('Kategorie wählen:'),
            SizedBox(height: 10),
            //Kategorie -------------------------------------------
            // DropDown(
            //     // dropdownItems: [ListItem(1, 'Konto1'), ListItem(1, 'Konto2')],
            //     dropdownItems: _accountDropDownItems,
            // ignore: todo
            //     //TODO: onChanged
            //     onChanged: () {}),
            // TextButton(onPressed: () {}, child: Text('Kategorie wählen: ')),
            Container(
              //height: 100,
              // padding: EdgeInsets.all(20),
              // color: Colors.grey[400]?.withOpacity(0.5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: AllData.categories
                      .map((item) => GestureDetector(
                            onTap: () => setState(() {
                              _selectedCategoryID = '${item.id}';
                            }),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: new Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: _selectedCategoryID == '${item.id}'
                                        ? 2.1
                                        : 1.0,
                                    color: _selectedCategoryID == '${item.id}'
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade700,
                                  ),
                                  color: Colors.grey.shade200,
                                ),
                                height:
                                    MediaQuery.of(context).size.width * 0.34,
                                width: MediaQuery.of(context).size.width * 0.29,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 5, right: 5),
                                  child: new Column(
                                    children: [
                                      CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          backgroundColor: item.color,
                                          child: FractionallySizedBox(
                                            widthFactor: 0.6,
                                            heightFactor: 0.6,
                                            child: Image.asset(
                                              item.symbol!,
                                              color: item.color!
                                                          .computeLuminance() >
                                                      0.2
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          )),
                                      SizedBox(height: 4),
                                      Center(
                                          child: Text(
                                        '${item.title}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: item.color),
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))

                      // new CircleAvatar(
                      //       radius: 40,
                      //       backgroundColor: item.color,
                      //       child: Text('${item.title}'),
                      //     ))
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Betrag',
              hintText: 'in €',
              keyboardType: TextInputType.number,
              controller: _amountController,
              mandatory: true,
              fieldname: 'amount',
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Bezeichnung',
              hintText: '',
              controller: _titleController,
              mandatory: true,
              fieldname: 'title',
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Beschreibung',
              hintText: '',
              controller: _descriptionController,
              mandatory: false,
              fieldname: 'description',
            ),
            SizedBox(
              height: 20,
            ),
            // Stack(
            //   children: [
            //     Container(
            //       padding: EdgeInsets.only(top: 10),
            //       alignment: Alignment.centerRight,
            //       child: Switch(
            //           value: _standingorderSwitch,
            //           onChanged: (value) {
            //             setState(() {
            //               _standingorderSwitch = value;
            //             });
            //           }),
            //     ),
            //Buchung ohne Dauerauftragoption, da man Dauerauftrag extra anlegen kann!
            // ExpansionTile(
            //   childrenPadding: EdgeInsets.only(left: 40),
            //   title: Text('Dauerauftrag'),
            //   initiallyExpanded: _standingorderSwitch,
            //   trailing: Text(''),
            //   onExpansionChanged: (value) {
            //     setState(() {
            //       _standingorderSwitch = value;
            //     });
            //   },
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('Beginn:'),
            //         Row(
            //           children: [
            //             Text(
            //                 '${_beginSO.day}. ${_beginSO.month}. ${_beginSO.year}'),
            //             IconButton(
            //               icon: Icon(Icons.date_range),
            //               onPressed: () {
            //                 showDatePicker(
            //                   context: context,
            //                   initialDate: _beginSO,
            //                   firstDate: DateTime.now()
            //                       .subtract(Duration(days: 365)),
            //                   lastDate:
            //                       DateTime.now().add(Duration(days: 365)),
            //                 ).then((value) =>
            //                     setState(() => _beginSO = value!));
            //               },
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('Wiederholung'),
            //         TextButton(
            //           onPressed: () => _repeatStandingorder(),
            //           child: Text('$_repeatValue'),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
        // ],
        // ),
      ),
    );
  }

  // void _repeatStandingorder() {
  //   CustomDialog().customShowDialog(
  //       context,
  //       'Wiederholung',
  //       Column(children: [
  //         TextButton(
  //           onPressed: () => _repeatValuePressed(0),
  //           child: Text('wöchentlich'),
  //           style: TextButton.styleFrom(
  //             primary: Colors.black,
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => _repeatValuePressed(1),
  //           child: Text('monatlich'),
  //           style: TextButton.styleFrom(
  //             primary: Colors.black,
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => _repeatValuePressed(2),
  //           child: Text('jährlich'),
  //           style: TextButton.styleFrom(
  //             primary: Colors.black,
  //           ),
  //         ),
  //       ]));
  // }

  // void _repeatValuePressed(int value) {
  //   switch (value) {
  //     case 0:
  //       _repeatValue = 'wöchentlich';
  //       break;
  //     case 1:
  //       _repeatValue = 'monatlich';
  //       break;
  //     case 2:
  //       _repeatValue = 'jährlich';
  //       break;
  //     default:
  //       return;
  //   }
  //   this.setState(() {});
  //   Navigator.pop(context, true);
  // }
}
