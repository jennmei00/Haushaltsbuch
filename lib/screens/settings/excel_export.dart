import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/expanstionTile_formField.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class ExcelExport extends StatefulWidget {
  const ExcelExport({Key? key}) : super(key: key);
  static final routeName = '/excel_export';

  @override
  State<ExcelExport> createState() => _ExcelExportState();
}

class _ExcelExportState extends State<ExcelExport> {
  Month _startMonth = Month.values[0];
  // int _startYear = Jiffy(DateTime.now()).subtract(years: 1).year;
  int _startYear = DateTime.now().year;
  Month _endMonth = Month.values[DateTime.now().month - 1];
  int _endYear = DateTime.now().year;
  List<Account> _selectedAccounts = [];
  List<Category> _variableExpenses = [];
  List<Category> _freetimeExpenses = [];
  bool _bigExpenses = false;
  TextEditingController _bigExpenseAmountController =
      TextEditingController(text: '1000');
  String _selectedAccountsText = 'no-accounts-selected'.i18n();
  List<int> _yearList = [
    Jiffy(DateTime.now()).subtract(years: 5).year,
    Jiffy(DateTime.now()).subtract(years: 4).year,
    Jiffy(DateTime.now()).subtract(years: 3).year,
    Jiffy(DateTime.now()).subtract(years: 2).year,
    Jiffy(DateTime.now()).subtract(years: 1).year,
    DateTime.now().year,
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Export'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Card(
                elevation: 5,
                child: ExpansionTile(
                  title: Text(
                    'date-range'.i18n(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${_startMonth.name}'.i18n() +
                      ' $_startYear - ' +
                      '${_endMonth.name}'.i18n() +
                      ' $_endYear'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(children: [
                            SizedBox(),
                            Text('month'.i18n(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('year'.i18n(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                          TableRow(children: [
                            Text('start'.i18n(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton(
                              items: Month.values
                                  .map((e) => DropdownMenuItem<Month>(
                                      child: Text('${e.name}'.i18n()),
                                      value: e))
                                  .toList(),
                              onChanged: (Month? val) {
                                setState(() {
                                  _startMonth = val!;
                                });
                              },
                              hint: Text(''),
                              value: _startMonth,
                            ),
                            DropdownButton(
                              items: _yearList
                                  .map((e) => DropdownMenuItem<int>(
                                      child: Text('$e'), value: e))
                                  .toList(),
                              onChanged: (int? val) {
                                setState(() {
                                  _startYear = val!;
                                });
                              },
                              hint: Text(''),
                              value: _startYear,
                            ),
                          ]),
                          TableRow(children: [
                            Text('end'.i18n(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton(
                              items: Month.values
                                  .map((e) => DropdownMenuItem<Month>(
                                      child: Text('${e.name}'.i18n()),
                                      value: e))
                                  .toList(),
                              onChanged: (Month? val) {
                                setState(() {
                                  _endMonth = val!;
                                });
                              },
                              hint: Text(''),
                              value: _endMonth,
                            ),
                            DropdownButton(
                              items: _yearList
                                  .map((e) => DropdownMenuItem<int>(
                                      child: Text('$e'), value: e))
                                  .toList(),
                              onChanged: (int? val) {
                                setState(() {
                                  _endYear = val!;
                                });
                              },
                              hint: Text(''),
                              value: _endYear,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                )),
            Card(
                elevation: 5,
                // child: Form(
                //     key: _formKey,
                child: ExpansionTileFormField(
                  title: Text(
                    'accounts'.i18n(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_selectedAccountsText),
                  children: AllData.accounts
                      .map((e) => ListTile(
                            title: Text('${e.title}'),
                            trailing: Checkbox(
                              value: _selectedAccounts.contains(e),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true)
                                    _selectedAccounts.add(e);
                                  else
                                    _selectedAccounts.remove(e);

                                  if (_selectedAccounts.length == 0)
                                    _selectedAccountsText =
                                        'no-accounts-selected'.i18n();
                                  else
                                    _selectedAccountsText = '';

                                  _selectedAccounts.forEach((e) {
                                    if (_selectedAccounts.last == e)
                                      _selectedAccountsText += '${e.title}';
                                    else
                                      _selectedAccountsText += '${e.title}, ';
                                  });
                                });
                              },
                            ),
                          ))
                      .toList(),
                  validator: (val) {
                    if (_selectedAccounts.length == 0) {
                      return 'select-account'.i18n();
                    } else
                      return null;
                  },
                )),
            Card(
              elevation: 5,
              child: ExpansionTileFormField(
                title: Text(
                  'variable-categories'.i18n(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                subtitle: Text(_variableExpenses.length == 1
                    ? '1 ${"category-selected".i18n()}'
                    : '${_variableExpenses.length} ${"categories-selected".i18n()}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        childAspectRatio: 0.7,
                        padding: EdgeInsets.all(4),
                        crossAxisCount: 4,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 0.02,
                        mainAxisSpacing: 2,
                        children: AllData.categories
                            .map((item) => CategoryItem(
                                  disabled: _freetimeExpenses.contains(item),
                                  categoryItem: item,
                                  selectedCatList: _variableExpenses,
                                  multiSelection: true,
                                  onTapFunction: _freetimeExpenses
                                          .contains(item)
                                      ? null
                                      : () => setState(() {
                                            final isSelected = _variableExpenses
                                                .contains(item);
                                            isSelected
                                                ? _variableExpenses.remove(item)
                                                : _variableExpenses.add(item);
                                          }),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
                validator: (val) {
                  if (_freetimeExpenses.length == 0 &&
                      _variableExpenses.length == 0) {
                    return 'select-categories'.i18n();
                  } else
                    return null;
                },
              ),
            ),
            Card(
              elevation: 5,
              child: ExpansionTileFormField(
                title: Text(
                  'freetime-categories'.i18n(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                subtitle: Text(_variableExpenses.length == 1
                    ? '1 ${"category-selected".i18n()}'
                    : '${_freetimeExpenses.length} ${"categories-selected".i18n()}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        childAspectRatio: 0.7,
                        padding: EdgeInsets.all(4),
                        crossAxisCount: 4,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 0.02,
                        mainAxisSpacing: 2,
                        children: AllData.categories
                            .map((item) => CategoryItem(
                                  disabled: _variableExpenses.contains(item),
                                  categoryItem: item,
                                  selectedCatList: _freetimeExpenses,
                                  multiSelection: true,
                                  onTapFunction: _variableExpenses
                                          .contains(item)
                                      ? null
                                      : () => setState(() {
                                            final isSelected = _freetimeExpenses
                                                .contains(item);
                                            isSelected
                                                ? _freetimeExpenses.remove(item)
                                                : _freetimeExpenses.add(item);
                                          }),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
                validator: (val) {
                  if (_freetimeExpenses.length == 0 &&
                      _variableExpenses.length == 0) {
                    return 'select-categories'.i18n();
                  } else
                    return null;
                },
              ),
            ),
            Card(
              elevation: 5,
              child: SwitchListTile(
                activeColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  'big-expenses'.i18n(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                value: _bigExpenses,
                onChanged: (val) => setState(() => _bigExpenses = val),
              ),
            ),
            !_bigExpenses
                ? SizedBox()
                : Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Text(
                        'big-expenses-amount'.i18n(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      title: CustomTextField(
                        controller: _bigExpenseAmountController,
                        mandatory: true,
                        fieldname: 'amount'.i18n(),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: false),
                      ),
                    ),
                  ),
            SizedBox(height: 60),
          ],
        ),
      ),
      // Container(
      //   child: Center(
      //     child: ElevatedButton(child: Text('Export'), onPressed: createExcel),
      //   ),
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () => _showPreview(), child: Text('preview'.i18n())),
          ElevatedButton(
              onPressed: () => _exportFile(), child: Text('export'.i18n()))
        ],
      ),
    );
  }

  Future<void> createExcel() async {
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
    sheet.getRangeByName('A2').setNumber(2);
    sheet.getRangeByName('A3').setNumber(5);
    sheet.getRangeByName('A4').setFormula('=A2+A3');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    print(path);
  }

  void _showPreview() {
    if (_checkIfSelected()) {
    } else
      return;
  }

  void _exportFile() {
    if (_checkIfSelected()) {
    } else
      return;
  }

  bool _checkIfSelected() {
    bool check = true;
    if (_formKey.currentState!.validate()) {
      check = false;
    }
    if (!check) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'snackbar-textfield'.i18n(),
          textAlign: TextAlign.center,
        ),
      ));
    }
    return check;
  }
}
