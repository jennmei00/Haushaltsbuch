import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:uuid/uuid.dart';

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
  bool _standingorderSwitch = false;
  // String _repeatValue = 'monatlich';
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  List<ListItem> _accountDropDownItems = [
    ListItem(0, 'name'),
    ListItem(1, ' ')
  ];

  Future<void> _getAccountDropDownItems() async {
    List<Account> accountList = [];
    accountList = await Account().listFromDB(await DBHelper.getData('Account'));
    if (accountList.length != 0) {
      _accountDropDownItems = [];
      accountList.forEach((element) {
        _accountDropDownItems.add(ListItem(1, element.title.toString()));
      });
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
        actions: [
          IconButton(
            onPressed: () {
              Posting posting = Posting(
                id: Uuid().v1(),
                title: _titleController.text,
                description: _descriptionController.text,
                // account: , //Ausgewähltes Konto
                amount: double.parse(_amountController.text),
                // category: , //Ausgewählte Kategorie
                date: _incomeDateTime,
                postingType: widget.type == 'Einnahme'
                    ? PostingType.income
                    : PostingType.expense,
              );
              DBHelper.insert('Posting', posting.toMap())
                  .then((value) => Navigator.pop(context));
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.save),
          ),
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
              SizedBox(
                height: 20,
              ),
              // CustomTextField(
              //   labelText: 'Konto',
              //   hintText: 'Kontoname',
              // ),
              DropDown(
                  // dropdownItems: [ListItem(1, 'Konto1'), ListItem(1, 'Konto2')],
                  dropdownItems: _accountDropDownItems,
                  //TODO: onChanged
                  onChanged: () {}),
              SizedBox(height: 20),
              //TODO: Kategorie PopUp bzw. Seite
              TextButton(onPressed: () {}, child: Text('Kategorie wählen: ')),
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
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: Switch(
                        value: _standingorderSwitch,
                        onChanged: (value) {
                          setState(() {
                            _standingorderSwitch = value;
                          });
                        }),
                  ),
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
            ],
          ),
        ),
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
