import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  List<ListItem> _accountDropDownItems = [];
  String _selectedCategoryID = '';
  Category _setCategory =
      AllData.categories.firstWhere((element) => element.id == 'default');
  late Category _selectedCategory;
  String? postingType;
  bool _postingSwitch = false;
  Account? _oldAccount;
  double? _oldAmount;
  int groupValueBuchungsart = 0;

  void _getAccountDropDownItems() {
    if (AllData.accounts.length != 0) {
      _accountDropDownItems = [];
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      setState(() {});
    }
  }

  void _getPostingsData() {
    Posting posting =
        AllData.postings.firstWhere((element) => element.id == widget.id);

    if (posting.account != null) {
      _selectedItem = _accountDropDownItems
          .firstWhere((element) => element.id == posting.account!.id);
    }

    _incomeDateTime = posting.date!;
    _amountController.text =
        NumberFormat("###.00", "de").format(posting.amount!);
    _titleController.text = '${posting.title}';
    _descriptionController.text = '${posting.description}';
    _setCategory = posting.category!;
    postingType =
        posting.postingType == PostingType.expense ? 'Ausgabe' : 'Einnahme';
    groupValueBuchungsart = posting.postingType!.index;
    if (posting.postingType == PostingType.expense)
      _postingSwitch = true;
    else
      _postingSwitch = false;

    _oldAccount = posting.account;
    _oldAmount = posting.amount;
  }

  @override
  void initState() {
    AllData.categories.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });

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
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _savePosting(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            children: [
              SizedBox(
                height: 10,
              ),
              widget.id == ''
                  ? SizedBox(
                      height: 0,
                    )
                  : FractionallySizedBox(
                      widthFactor: 0.9,
                      child: CupertinoSlidingSegmentedControl(
                        children: <Object, Widget>{
                          0: Text('Einnahme'),
                          1: Text('Ausgabe')
                        },
                        onValueChanged: (val) {
                          setState(() {
                            groupValueBuchungsart = val as int;
                            postingType =
                                PostingType.values[groupValueBuchungsart] ==
                                        PostingType.expense
                                    ? 'Ausgabe'
                                    : 'Einnahme';
                          });
                        },
                        groupValue: groupValueBuchungsart,
                      ),
                    ),
              SizedBox(height: 20),
              DropDown(
                onChanged: (newValue) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectedItem = newValue as ListItem;
                  setState(() {});
                },
                dropdownItems: _accountDropDownItems,
                listItemValue: _selectedItem == null ? null : _selectedItem!.id,
                dropdownHintText: 'Konto',
              ),
              _selectedItem == null && widget.id != ''
                  ? Text('Das eigentliche Konto wurde gelöscht')
                  : SizedBox(),
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
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Popup(
                                title: 'Kategorien',
                                body: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  height:
                                      MediaQuery.of(context).size.height * 0.48,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: GridView.count(
                                    scrollDirection: Axis.vertical,
                                    childAspectRatio:
                                        0.7, //MediaQuery.of(context)
                                    //     .size
                                    //     .width /
                                    // (MediaQuery.of(context).size.height / 1.6),
                                    padding: EdgeInsets.all(10),
                                    crossAxisCount: 3,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    mainAxisSpacing: 12,
                                    children: AllData.categories
                                        .map((item) => CategoryItem(
                                              categoryItem: item,
                                              selectedCatID:
                                                  _selectedCategoryID,
                                              onTapFunction: () => setState(() {
                                                _selectedCategoryID =
                                                    '${item.id}';
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
                          });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Datum:'),
                  Row(
                    children: [
                      GestureDetector(
                        child: Text(formatDate(_incomeDateTime)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());

                          showDatePicker(
                            context: context,
                            initialDate: _incomeDateTime,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          ).then(
                            (value) {
                              if (value != null)
                                setState(() => _incomeDateTime = value);
                            },
                          );
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            showDatePicker(
                              context: context,
                              initialDate: _incomeDateTime,
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _incomeDateTime = value);
                              },
                            );
                          }),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _savePosting() async {
    String stringAmount = _amountController.text.replaceAll('.', '');
    stringAmount = stringAmount.replaceAll(',', '.');
    if (_formKey.currentState!.validate()) {
      try {
        Posting posting = Posting(
          id: widget.id != '' ? widget.id : Uuid().v1(),
          title: _titleController.text,
          description: _descriptionController.text,
          account: AllData.accounts
              .firstWhere((element) => element.id == _selectedItem!.id),
          amount: double.parse(stringAmount),
          date: _incomeDateTime,
          postingType: widget.id == ''
              ? widget.type == 'Einnahme'
                  ? PostingType.income
                  : PostingType.expense
              : PostingType.values[groupValueBuchungsart],
          category: _setCategory,
          accountName: AllData.accounts
              .firstWhere((element) => element.id == _selectedItem!.id)
              .title,
          standingOrder: null,
          isStandingOrder: false,
        );

        if (widget.id == '') {
          //add function
          await DBHelper.insert('Posting', posting.toMap());
          Account ac = AllData.accounts
              .firstWhere((element) => element.id == posting.account!.id);
          AllData.accounts.remove(ac);
          if (posting.postingType == PostingType.income)
            ac.bankBalance = ac.bankBalance! + posting.amount!;
          else
            ac.bankBalance = ac.bankBalance! - posting.amount!;
          AllData.accounts.add(ac);
          await DBHelper.update('Account', ac.toMap(),
              where: "ID = '${ac.id}'");
        } else {
          //edit function
          await DBHelper.update('Posting', posting.toMap(),
              where: "ID = '${posting.id}'");

          Account ac = AllData.accounts
              .firstWhere((element) => element.id == posting.account!.id);
          AllData.accounts.removeWhere((element) => element.id == ac.id);

          if (_oldAccount == posting.account) {
            //if account didnt change
            if (_postingSwitch) //expense
              ac.bankBalance =
                  ac.bankBalance! + (_oldAmount! - posting.amount!);
            else //income
              ac.bankBalance =
                  ac.bankBalance! - (_oldAmount! - posting.amount!);
          } else {
            //if account changed
            if (_oldAccount != null) {
              AllData.accounts
                  .removeWhere((element) => element.id == _oldAccount!.id);
              if (_postingSwitch) {
                //expense

                ac.bankBalance = ac.bankBalance! - posting.amount!;
                _oldAccount!.bankBalance =
                    _oldAccount!.bankBalance! + _oldAmount!;
              } else {
                //income
                ac.bankBalance = ac.bankBalance! + posting.amount!;
                _oldAccount!.bankBalance =
                    _oldAccount!.bankBalance! - _oldAmount!;
              }

              await DBHelper.update('Account', _oldAccount!.toMap(),
                  where: "ID = '${_oldAccount!.id}'");
              AllData.accounts.add(_oldAccount!);
            }
          }

          await DBHelper.update('Account', ac.toMap(),
              where: "ID = '${ac.id}'");

          AllData.accounts.add(ac);
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
}
