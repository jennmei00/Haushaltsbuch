import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;

class IncomeCircularChart extends StatefulWidget {
  const IncomeCircularChart({Key? key}) : super(key: key);

  @override
  _IncomeCircularChartState createState() => _IncomeCircularChartState();
}

class _IncomeCircularChartState extends State<IncomeCircularChart> {
  DateTime _yearValue = DateTime.now();
  DateTime _monthValue = DateTime(2000, DateTime.now().month, 01);
  String _selectedAccounts = '';
  List<Account> _filterAccounts = [];
  double _totalIncomes = 0;

  void selectAllAccounts() {
    AllData.accounts.forEach((element) {
      if (Globals.accountVisibility[element.id] == true)
        _filterAccounts.add(element);
    });
    _filterAccounts.forEach((e) {
      if (_filterAccounts.last == e)
        _selectedAccounts += '${e.title}';
      else
        _selectedAccounts += '${e.title}, ';
    });
  }

  @override
  void initState() {
    selectAllAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _totalIncomes = 0;
    _getDatasource().forEach((element) {
      _totalIncomes += element.y;
    });
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 5.0, left: 5.0, bottom: 8.0, top: 20.0),
            child: Column(children: [
              Text(
                'year'.i18n(),
                style: Theme.of(context).textTheme.headline6,
              ),
              slider.SfSlider(
                min: DateTime(DateTime.now().year - 4, 01, 01),
                max: DateTime.now(),
                showLabels: true,
                interval: 1,
                stepDuration: const slider.SliderStepDuration(years: 1),
                dateFormat: DateFormat.y(),
                labelPlacement: slider.LabelPlacement.onTicks,
                dateIntervalType: slider.DateIntervalType.years,
                showTicks: true,
                value: _yearValue,
                onChanged: (dynamic values) {
                  setState(() {
                    _yearValue = values as DateTime;
                  });
                },
                enableTooltip: true,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'month'.i18n(),
                style: Theme.of(context).textTheme.headline6,
              ),
              slider.SfSlider(
                min: DateTime(2000, 01, 01),
                max: DateTime(2000, 12, 01),
                showLabels: true,
                interval: 1,
                stepDuration: const slider.SliderStepDuration(months: 1),
                dateFormat:
                    DateFormat.M(Localizations.localeOf(context).languageCode),
                labelPlacement: slider.LabelPlacement.onTicks,
                dateIntervalType: slider.DateIntervalType.months,
                showTicks: true,
                value: _monthValue,
                onChanged: (dynamic values) {
                  setState(() {
                    _monthValue = values as DateTime;
                  });
                },
                enableTooltip: true,
                tooltipTextFormatterCallback:
                    (dynamic actualLabel, String formattedText) {
                  return DateFormat.MMMM(
                          Localizations.localeOf(context).languageCode)
                      .format(actualLabel);
                },
              ),
            ]),
          ),
          _getDatasource().length == 0
              ? SizedBox()
              : SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: _getPieSeries(),
                ),
          Text("${'total-incomes'.i18n()}: ${formatCurrency(_totalIncomes)}"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              color: Globals.isDarkmode ? null : Color(0xffeeeeee),
              child: ExpansionTile(
                title: Text(
                  'pick-account'.i18n(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: _selectedAccounts == ''
                    ? Text('no-accounts-selected'.i18n())
                    : Text(_selectedAccounts),
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
                                    _selectedAccounts =
                                        'no-accounts-selected'.i18n();
                                  else
                                    _selectedAccounts = '';

                                  _filterAccounts.forEach((e) {
                                    if (_filterAccounts.last == e)
                                      _selectedAccounts += '${e.title}';
                                    else
                                      _selectedAccounts += '${e.title}, ';
                                  });
                                });
                              }),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_ChartData> _getDatasource() {
    List<_ChartData> source = [];

    AllData.categories.forEach((element) {
      double amount = 0;

      AllData.postings
          .where((p) => p.category!.id == element.id)
          .forEach((posting) {
        if (posting.postingType == PostingType.income) {
          if (posting.date!.year == _yearValue.year &&
              posting.date!.month ==
                  _monthValue.month) if (_filterAccounts
              .contains(posting.account)) {
            amount += posting.amount!;
          }
        }
      });
      if (amount != 0)
        source.add(_ChartData(element.title!, amount,
            '${element.title}\n${formatCurrency(amount)}'));
    });

    return source;
  }

  List<PieSeries<_ChartData, String>> _getPieSeries() {
    return <PieSeries<_ChartData, String>>[
      PieSeries<_ChartData, String>(
        dataSource: _getDatasource(),
        xValueMapper: (_ChartData data, _) => data.x,
        yValueMapper: (_ChartData data, _) => data.y,
        dataLabelMapper: (_ChartData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.text);
  final String x;
  final double y;
  final String text;
}
