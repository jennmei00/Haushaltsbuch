import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';

class YearOverviewTable extends StatefulWidget {
  YearOverviewTable({Key? key}) : super(key: key);

  @override
  State<YearOverviewTable> createState() => _YearOverviewTableState();
}

class _YearOverviewTableState extends State<YearOverviewTable> {
  final int currentYear = DateTime.now().year;
  String _selectedAccounts = 'Keine Konten ausgewählt';
  List<Account> _filterAccounts = [];
  double incomeValue = 0;
  double expenseValue = 0;
  double rest = 0;
  double cellPadding = 15;

  double getIncomeValue() {
    double incomeVal = 0;
    _filterAccounts.forEach((ac) {
      AllData.postings
          .where((posting) =>
              posting.account!.id == ac.id &&
              posting.postingType == PostingType.income)
          .forEach((e) {
        incomeVal += e.amount!;
      });
    });
    return incomeVal;
  }

  double getExpenseValue() {
    double expenseVal = 0;
    _filterAccounts.forEach((ac) {
      AllData.postings
          .where((posting) =>
              posting.account!.id == ac.id &&
              posting.postingType == PostingType.expense)
          .forEach((e) {
        expenseVal += e.amount!;
      });
    });
    return expenseVal;
  }

  double getRestValue() {
    double restVal = 0;
    restVal = incomeValue - expenseValue;
    return restVal;
  }

  Color _getRestValColor(double balance) {
    if (balance < 0) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            '$currentYear',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                  width: 0.5),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        'Einnahmen',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        '${formatCurrency(incomeValue)}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        'Ausgaben',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        '${formatCurrency(expenseValue)}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        'Rest',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(cellPadding),
                      child: Text(
                        '${formatCurrency(rest)}',
                        style: TextStyle(
                          color: _getRestValColor(rest),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Card(
            elevation: 3,
            color: Globals.isDarkmode ? null : Color(0xffeeeeee),
            child: ExpansionTile(
              title: Text(
                'Auswahl der Konten',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_selectedAccounts),
              children: AllData.accounts
                  .map((e) => ListTile(
                        title: Text('${e.title}'),
                        trailing: Checkbox(
                            value: _filterAccounts.contains(e),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _filterAccounts.add(e);
                                } else {
                                  _filterAccounts.remove(e);
                                }
                                if (_filterAccounts.length == 0)
                                  _selectedAccounts = 'Keine Konten ausgewählt';
                                else
                                  _selectedAccounts = '';

                                _filterAccounts.forEach((e) {
                                  if (_filterAccounts.last == e)
                                    _selectedAccounts += '${e.title}';
                                  else
                                    _selectedAccounts += '${e.title}, ';
                                });
                                incomeValue = getIncomeValue();
                                expenseValue = getExpenseValue();
                                rest = getRestValue();
                              });
                            }),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
