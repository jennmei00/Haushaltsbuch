import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class IncomeExpenseScreen extends StatefulWidget {
  static final routeName = '/income_expense_screen';
  final String type;
  final String id;

  IncomeExpenseScreen({this.type = '', this.id = ''});

  @override
  _IncomeExpenseScreenState createState() => _IncomeExpenseScreenState();
}

class _IncomeExpenseScreenState extends State<IncomeExpenseScreen> {
  ListItem? _selectedItem;
  DateTime _incomeDateTime = DateTime.now();
  // DateTime _beginSO = DateTime.now();
  // bool _standingorderSwitch = false;
  // String _repeatValue = 'monatlich';
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  List<ListItem> _accountDropDownItems = [];
  //late ListItem _selectedItem;
  String _selectedCategoryID = '';
  Category _setCategory = Category(
      id: 'default',
      symbol: 'assets/icons/food.png',
      color: Colors.blue,
      title: 'Defaultkat');
  late Category _selectedCategory;
  String? postingType;
  bool _postingSwitch = false;

  void _getAccountDropDownItems() {
    //_selectedItem = ListItem('0', 'name');
    if (AllData.accounts.length != 0) {
      _accountDropDownItems = [];
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      //_selectedItem = _accountDropDownItems.first;
      setState(() {});
    }
  }

  void _getPostingsData() {
    Posting posting =
        AllData.postings.firstWhere((element) => element.id == widget.id);

    _selectedItem = _accountDropDownItems
        .firstWhere((element) => element.id == posting.account!.id);

    _incomeDateTime = posting.date!;
    _amountController.text = '${posting.amount}';
    _titleController.text = '${posting.title}';
    _descriptionController.text = '${posting.description}';
    _setCategory = posting.category!;
    postingType =
        posting.postingType == PostingType.expense ? 'Ausgabe' : 'Einnahme';
  }

  @override
  void initState() {
    _getAccountDropDownItems();
    if (widget.id != '') {
      _getPostingsData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            postingType != null ? '$postingType bearbeiten' : '${widget.type}'),
        // backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _savePosting(),
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
                Text('Datum:'),
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
                        ).then((value) {
                          if (value != null)
                            setState(() => _incomeDateTime = value);
                        });
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
              onChanged: (newValue) {
                _selectedItem = newValue as ListItem;
                setState(() {});
              },
              dropdownItems: _accountDropDownItems,
              listItemValue: _selectedItem == null ? null : _selectedItem!.id,
              dropdownHintText: 'Konto',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 120,
                  child: CategoryItem(
                    categoryItem: _setCategory,
                  ),
                ),
                ElevatedButton(
                  child: Text('Kategorie ändern'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Popup(
                            title: 'Kategorien',
                            body: Container(
                              //color: Colors.blue,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              height: MediaQuery.of(context).size.height * 0.48,
                              width: MediaQuery.of(context).size.width * 1,
                              child: GridView.count(
                                scrollDirection: Axis.vertical,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 1.5),
                                padding: EdgeInsets.all(10),
                                crossAxisCount: 3,
                                crossAxisSpacing:
                                    MediaQuery.of(context).size.width * 0.04,
                                mainAxisSpacing: 12,
                                children: AllData.categories
                                    .map((item) => CategoryItem(
                                          categoryItem: item,
                                          selectedCatID: _selectedCategoryID,
                                          onTapFunction: () => setState(() {
                                            _selectedCategoryID = '${item.id}';
                                            _selectedCategory = item;
                                          }),
                                        ))
                                    .toList(),
                              ),
                            ),
                            saveButton: true,
                            cancelButton: true,
                            saveFunction: () {
                              this.setState(() {
                                _setCategory = _selectedCategory;
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Einnahme',
                  style: TextStyle(color: Colors.green),
                ),
                Switch(
                  value: _postingSwitch, onChanged: (val) {
                    if (val) {
                      //PostingType change to Ausgabe
                    } else {
                      //PostingType change to Einnahme
                    }
                  },
                  activeColor: Colors.red,
                  activeTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.green,
                  inactiveTrackColor: Colors.grey,
                ),
                Text(
                  'Ausgabe',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )
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

  void _savePosting() async {
    if (_formKey.currentState!.validate()) {
      try {
        Posting posting = Posting(
          id: widget.id != '' ? widget.id : Uuid().v1(),
          title: _titleController.text,
          description: _descriptionController.text,
          account: AllData.accounts.firstWhere((element) =>
              element.id == _selectedItem!.id), //Ausgewähltes Konto
          amount: double.parse(_amountController.text),
          date: _incomeDateTime,
          postingType: widget.type == 'Einnahme'
              ? PostingType.income
              : PostingType.expense,
          category: AllData.categories.firstWhere((element) =>
              element.id == _selectedCategoryID), //Ausgewählte Kategorie
          accountName: AllData.accounts
              .firstWhere((element) => element.id == _selectedItem!.id)
              .title,
        );

        if (widget.id == '') {
          await DBHelper.insert('Posting', posting.toMap());
        } else {
          await DBHelper.update('Posting', posting.toMap(),
              where: "ID = '${posting.id}'");
          AllData.postings.removeWhere((element) => element.id == posting.id);
        }

        AllData.postings.add(posting);
        Navigator.pop(context);
      } catch (ex) {
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
