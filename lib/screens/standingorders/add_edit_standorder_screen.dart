import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/standingorders/standingorders_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEditStandingOrder extends StatefulWidget {
  static final routeName = '/edit_standingorder_screen';

  final String id;

  AddEditStandingOrder({this.id = ''});

  @override
  _AddEditStandingOrderState createState() => _AddEditStandingOrderState();
}

class _AddEditStandingOrderState extends State<AddEditStandingOrder> {
  DateTime _dateTime = DateTime.now();
  DateTime? _dateTimeEnd;
  Repetition _repeatValue = Repetition.monthly;
  int _groupValue_buchungsart = 0;
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  ListItem? _selectedItem;
  ListItem? _selectedItemTo;
  String _selectedCategoryID = '';
  Category _setCategory =
      AllData.categories.firstWhere((element) => element.id == 'default');
  late Category _selectedCategory;
  List<ListItem> _accountDropDownItems = [];
  bool _isTransfer = false;

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

  void _getStandingOrderData() {
    StandingOrder so =
        AllData.standingOrders.firstWhere((element) => element.id == widget.id);
    _repeatValue = so.repetition!;
    _groupValue_buchungsart = so.postingType!.index;
    _dateTime = so.begin!;
    _dateTimeEnd = so.end == null ? null : so.end!;
    _selectedItem = _accountDropDownItems
        .firstWhere((element) => element.id == so.account!.id);
    _selectedItemTo = so.accountTo == null
        ? null
        : _accountDropDownItems
            .firstWhere((element) => element.id == so.accountTo!.id);
    _setCategory =
        so.category == null ? AllData.categories.first : so.category!;
    _amountController.text = NumberFormat("##0.00", "de").format(so.amount!);
    _titleController.text = so.title == null ? '' : so.title!;
    _descriptionController.text = so.description!;
    _isTransfer = so.postingType == PostingType.transfer ? true : false;
  }

  @override
  void initState() {
    AllData.categories.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });
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
            onPressed: () => _saveStandingorder(),
          )
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
              FractionallySizedBox(
                widthFactor: 0.9,
                child: CupertinoSlidingSegmentedControl(
                  children: <Object, Widget>{
                    0: Text('Einnahme'),
                    1: Text('Ausgabe'),
                    2: Text('Umbuchung'),
                  },
                  onValueChanged: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    setState(() {
                      _groupValue_buchungsart = val as int;
                      if (val == 2)
                        _isTransfer = true;
                      else
                        _isTransfer = false;
                    });
                  },
                  groupValue: _groupValue_buchungsart,
                ),
              ),
              SizedBox(height: 20),
              DropDown(
                onChanged: (newValue) {
                  _selectedItem = newValue as ListItem;
                  setState(() {});
                },
                dropdownItems: _accountDropDownItems,
                listItemValue: _selectedItem == null ? null : _selectedItem!.id,
                dropdownHintText: _isTransfer ? 'Von Konto' : 'Konto',
              ),
              _isTransfer
                  ? Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          height: 65,
                          child: Image.asset(
                            'assets/icons/other_icons/arrow.png',
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 20),
                        DropDown(
                          onChanged: (newValue) {
                            _selectedItemTo = newValue as ListItem;
                            setState(() {});
                          },
                          dropdownItems: _accountDropDownItems,
                          listItemValue: _selectedItemTo == null
                              ? null
                              : _selectedItemTo!.id,
                          dropdownHintText: 'Zu Konto',
                        )
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Betrag',
                hintText: 'in €',
                keyboardType: TextInputType.number,
                controller: _amountController,
                mandatory: true,
                fieldname: 'amount',
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: _isTransfer ? 0 : 20),
              _isTransfer
                  ? SizedBox()
                  : CustomTextField(
                      labelText: 'Bezeichnung',
                      hintText: '',
                      controller: _titleController,
                      mandatory: true,
                      fieldname: 'title',
                      textInputAction: TextInputAction.next,
                    ),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'Beschreibung',
                hintText: '',
                controller: _descriptionController,
                mandatory: false,
                fieldname: 'description',
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(height: 20),
              _isTransfer
                  ? SizedBox()
                  : Row(
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Popup(
                                      title: 'Kategorien',
                                      body: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.48,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        child: GridView.count(
                                          scrollDirection: Axis.vertical,
                                          childAspectRatio:
                                              0.7, //MediaQuery.of(context)
                                          //     .size
                                          //     .width /
                                          // (MediaQuery.of(context).size.height / 1.5),
                                          padding: EdgeInsets.all(10),
                                          crossAxisCount: 3,
                                          crossAxisSpacing:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                          mainAxisSpacing: 12,
                                          children: AllData.categories
                                              .map((item) => CategoryItem(
                                                    categoryItem: item,
                                                    selectedCatID:
                                                        _selectedCategoryID,
                                                    onTapFunction: () =>
                                                        setState(() {
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
              SizedBox(
                height: 10,
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Beginn:'),
                    Row(
                      children: [
                        GestureDetector(
                          child: Text(formatDate(_dateTime)),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showDatePicker(
                              context: context,
                              initialDate: _dateTime,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _dateTime = value);
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
                              initialDate: _dateTime,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _dateTime = value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ende:'),
                    Row(
                      children: [
                        GestureDetector(
                          child: _dateTimeEnd == null
                              ? Text('Datum wählen')
                              : Text(formatDate(_dateTimeEnd!)),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showDatePicker(
                              context: context,
                              initialDate: _dateTimeEnd == null
                                  ? DateTime.now()
                                  : _dateTimeEnd!,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _dateTimeEnd = value);
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
                              initialDate: _dateTimeEnd == null
                                  ? DateTime.now()
                                  : _dateTimeEnd!,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _dateTimeEnd = value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 35.0, right: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wiederholung:'),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _repeatStandingorder();
                      },
                      child: Text('${formatRepetition(_repeatValue)}'),
                    ),
                  ],
                ),
              ),
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                RadioListTile<Repetition>(
                  title: Text('Wöchentlich'),
                  value: Repetition.weekly,
                  groupValue: _repeatValue,
                  onChanged: (val) {
                    setState(() {
                      _repeatValue = val!;
                    });
                    Navigator.pop(context, true);
                  },
                ),
                Divider(),
                RadioListTile<Repetition>(
                  title: Text('Monatlich'),
                  value: Repetition.monthly,
                  groupValue: _repeatValue,
                  onChanged: (val) {
                    setState(() {
                      _repeatValue = val!;
                    });
                    Navigator.pop(context, true);
                  },
                ),
                Divider(),
                RadioListTile<Repetition>(
                  title: Text('Vierteljährlich'),
                  value: Repetition.quarterly,
                  groupValue: _repeatValue,
                  onChanged: (val) {
                    setState(() {
                      _repeatValue = val!;
                    });
                    Navigator.pop(context, true);
                  },
                ),
                Divider(),
                RadioListTile<Repetition>(
                  title: Text('Halbjährlich'),
                  value: Repetition.halfYearly,
                  groupValue: _repeatValue,
                  onChanged: (val) {
                    setState(() {
                      _repeatValue = val!;
                    });
                    Navigator.pop(context, true);
                  },
                ),
                Divider(),
                RadioListTile<Repetition>(
                  title: Text('Jährlich'),
                  value: Repetition.yearly,
                  groupValue: _repeatValue,
                  onChanged: (val) {
                    setState(() {
                      _repeatValue = val!;
                    });
                    Navigator.pop(context, true);
                  },
                ),
              ]),
            ),
            saveButton: false,
            cancelButton: true,
          );
        });
  }

  void _saveStandingorder() async {
    String stringAmount = _amountController.text.replaceAll('.', '');
    stringAmount = stringAmount.replaceAll(',', '.');
    if (_formKey.currentState!.validate()) {
      try {
        StandingOrder so = StandingOrder(
            id: widget.id != '' ? widget.id : Uuid().v1(),
            title: _titleController.text,
            description: _descriptionController.text,
            amount: double.parse(stringAmount),
            account: AllData.accounts
                .firstWhere((element) => element.id == _selectedItem!.id),
            accountTo: AllData.accounts
                .firstWhere((element) => element.id == _selectedItemTo!.id),
            category: _setCategory,
            begin: DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
            end: _dateTimeEnd == null
                ? null
                : DateTime(
                    _dateTimeEnd!.year, _dateTimeEnd!.month, _dateTimeEnd!.day),
            postingType: PostingType.values[_groupValue_buchungsart],
            repetition: _repeatValue);

        if (widget.id == '') {
          await DBHelper.insert('Standingorder', so.toMap());
          if (so.begin!.isBefore(DateTime.now())) {
            if (so.postingType != PostingType.transfer) {
              Posting p = Posting(
                id: Uuid().v1(),
                title: so.title,
                description: so.description,
                account: so.account,
                amount: so.amount,
                date: so.begin,
                postingType: so.postingType,
                category: so.category,
                accountName: so.account?.title,
                standingOrder: so,
                isStandingOrder: true,
              );

              AllData.postings.add(p);
              await DBHelper.insert('Posting', p.toMap());

              //update AccountAmount
              Account ac = AllData.accounts
                  .firstWhere((element) => element.id == p.account!.id);
              if (p.postingType == PostingType.income)
                AllData
                    .accounts[AllData.accounts
                        .indexWhere((element) => element.id == ac.id)]
                    .bankBalance = ac.bankBalance! + p.amount!;
              else
                AllData
                    .accounts[AllData.accounts
                        .indexWhere((element) => element.id == ac.id)]
                    .bankBalance = ac.bankBalance! - p.amount!;

              await DBHelper.update('Account', ac.toMap(),
                  where: "ID = '${ac.id}'");
            } else {
              Transfer t = Transfer(
                id: Uuid().v1(),
                description: so.description,
                accountFrom: so.account,
                accountFromName: so.account?.title,
                accountTo: so.accountTo,
                accountToName: so.accountTo?.title,
                amount: so.amount,
                date: so.begin,
                standingOrder: so,
                isStandingOrder: true,
              );

              AllData.transfers.add(t);
              await DBHelper.insert('Transfer', t.toMap());

              //update AccountAmount
              Account acFrom = AllData.accounts
                  .firstWhere((element) => element.id == t.accountFrom!.id);
              Account acTo = AllData.accounts
                  .firstWhere((element) => element.id == t.accountTo!.id);

              AllData
                  .accounts[AllData.accounts
                      .indexWhere((element) => element.id == acFrom.id)]
                  .bankBalance = acFrom.bankBalance! - t.amount!;
              AllData
                  .accounts[AllData.accounts
                      .indexWhere((element) => element.id == acTo.id)]
                  .bankBalance = acTo.bankBalance! + t.amount!;

              await DBHelper.update('Account', acTo.toMap(),
                  where: "ID = '${acTo.id}'");
              await DBHelper.update('Account', acFrom.toMap(),
                  where: "ID = '${acFrom.id}'");
            }
          }
        } else {
          await DBHelper.update('Standingorder', so.toMap(),
              where: "ID = '${so.id}'");

          AllData.standingOrders.removeWhere((element) => element.id == so.id);
        }
        AllData.standingOrders.add(so);

        Navigator.of(context)
          ..pop()
          ..popAndPushNamed(StandingOrdersScreen.routeName);
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
