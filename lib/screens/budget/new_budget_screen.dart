import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:intl/intl.dart';

class NewBudgetScreen extends StatefulWidget {
  static final routeName = '/new_budget_screen';

  final String id;

  NewBudgetScreen({this.id = ''});

  @override
  State<NewBudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<NewBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  Category _setCategory =
      AllData.categories.firstWhere((element) => element.id == 'default');
  late Category _selectedCategory;
  String _selectedCategoryID = '';
  TextEditingController _amountController = TextEditingController(text: '');
  int _groupValueBudgetTime = 0;
  int _groupValueBudgetRepetition = 0;
  List<String> monthList = [];
  List<int> weekList = new List<int>.generate(52, (i) => i + 1);
  DateTime currentDate = new DateTime.now();
  int currentCalendarWeek = 0;

  void _fillMonthList() {
    Month.values.forEach((element) {
      monthList.add(element.toString().split('.').elementAt(1));
    });
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  void initState() {
    _fillMonthList();
    currentCalendarWeek = weekNumber(currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Budget'),
        centerTitle: true,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.48,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
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
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: 'Betrag',
                      hintText: 'in €',
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                      mandatory: true,
                      fieldname: 'amount',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: SimpleCalculator(
                                  value: _amountController.text == ''
                                      ? 0
                                      : double.tryParse(_amountController.text
                                          .replaceAll(',', '.'))!,
                                  onChanged: (key, value, expression) {
                                    if (key == '=') {
                                      _amountController.text =
                                          value.toString().replaceAll('.', ',');
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.calculate),
                    iconSize: 40,
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CupertinoSlidingSegmentedControl(
                    children: <Object, Widget>{
                      0: Text('Woche'),
                      1: Text('Monat')
                    },
                    onValueChanged: (val) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        _groupValueBudgetTime = val as int;
                      });
                    },
                    groupValue: _groupValueBudgetTime,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CupertinoSlidingSegmentedControl(
                    children: <Object, Widget>{
                      0: Text('Einmalig in'),
                      1: Text('Laufend ab')
                    },
                    onValueChanged: (val) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        _groupValueBudgetRepetition = val as int;
                      });
                    },
                    groupValue: _groupValueBudgetRepetition,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _groupValueBudgetTime == 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Kalenderwoche',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: CupertinoPicker(
                                  itemExtent: 40,
                                  children: weekList
                                      .map((e) => Center(
                                              child: Text(
                                            e.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          )))
                                      .toList(),
                                  onSelectedItemChanged: (index) {},
                                  looping: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Aktuelle Kalenderwoche ist ' +
                                currentCalendarWeek.toString() +
                                '.',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Monat',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: CupertinoPicker(
                              itemExtent: 40,
                              children: monthList
                                  .map((e) => Center(
                                          child: Text(
                                        e,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )))
                                  .toList(),
                              onSelectedItemChanged: (index) {},
                              looping: true,
                            ),
                          ),
                        ],
                      )
              ]),
        ),
      ),
    );
  }
}
