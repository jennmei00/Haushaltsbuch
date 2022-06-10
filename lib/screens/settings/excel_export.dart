import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
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
  DateTimeRange? _dateRange;
  // DateTimeRange _dateRange = DateTimeRange(start: DateTime.now().subtract(Duration(days: 60)), end: DateTime.now());
  List<Account> _selectedAccounts = [];
  List<Category> _variableExpenses = [];
  List<Category> _freetimeExpenses = [];
  bool _bigExpenses = false;
  TextEditingController _bigExpenseAmountController = TextEditingController(text: '1000');
  double _bigExpenseAmount = 1000;
  String _selectedAccountsText = 'no-accounts-selected'.i18n();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Export'),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'date-range'.i18n(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        _dateRange == null
                            ? 'click-to-select'.i18n()
                            : '${formatDate(_dateRange!.start, context)} - ' +
                                '\n ${formatDate(_dateRange!.end, context)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                        textAlign: TextAlign.end,
                      ),
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: AllData.postings.length == 0
                              ? DateTime.now().subtract(Duration(days: 30))
                              : AllData.postings.last.date!,
                          lastDate: DateTime.now().add(Duration(days: 30)),
                          currentDate: DateTime.now(),
                        );

                        setState(() {
                          _dateRange = picked;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: AllData.postings.length == 0
                            ? DateTime.now().subtract(Duration(days: 30))
                            : AllData.postings.last.date!,
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );

                      setState(() {
                        _dateRange = picked;
                      });
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: ExpansionTile(
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
            ),
          ),
          Card(
            elevation: 5,
            child: ExpansionTile(
              // children: [
              title:
                  // Container(
                  //   padding: EdgeInsets.only(left: 16, top: 18),
                  //   width: double.infinity,
                  //   child:
                  Text(
                'variable-categories'.i18n(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.left,
                // ),
              ),
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
                                onTapFunction: _freetimeExpenses.contains(item)
                                    ? null
                                    : () => setState(() {
                                          final isSelected =
                                              _variableExpenses.contains(item);
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
            ),
          ),
          Card(
            elevation: 5,
            child: ExpansionTile(
              // Column(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.only(left: 16, top: 18),
              //       width: double.infinity,
              //       child:
              title: Text(
                'freetime-categories'.i18n(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.left,
              ),
              // ),
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
                                onTapFunction: _variableExpenses.contains(item)
                                    ? null
                                    : () => setState(() {
                                          final isSelected =
                                              _freetimeExpenses.contains(item);
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    title: CustomTextField(
                        controller: _bigExpenseAmountController,
                        mandatory: true,
                        fieldname: 'amount'.i18n(),
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        ),
                  ),
                ),
        ],
      ),
      // Container(
      //   child: Center(
      //     child: ElevatedButton(child: Text('Export'), onPressed: createExcel),
      //   ),
      // ),
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
}
