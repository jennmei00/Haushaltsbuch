import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  bool _oneYearIsDisabled = false;
  bool _sixMonthsIsDisabled = false;
  bool _threeMonthsIsDisabled = false;
  bool _oneMonthIsDisabled = false;

  DateTimeRange _dateRange = DateTimeRange(
      start:
          Jiffy.parseFromDateTime(DateTime.now()).subtract(months: 3).dateTime,
      end: DateTime.now());

  DateTime firstAccountCreation = DateTime.now();

  List<_ChartData> _getChartData(Account element) {
    List<_ChartData> _chartData = <_ChartData>[];

    if (element.creationDate!.isBefore(firstAccountCreation))
      firstAccountCreation = element.creationDate!;

    var firstDate = getMondayOfWeek(element.creationDate!);
    double firstBankBalance = _getFirstBankBalance(element);

    _chartData.add(_ChartData(
      firstDate,
      firstBankBalance,
    ));

    if (AllData.postings
            .where((val) =>
                val.account == null ? false : val.account!.id == element.id)
            .length ==
        0) {
      _chartData.add(_ChartData(DateTime.now(), firstBankBalance));
    } else {
      int i = 0;
      double newAmount = firstBankBalance;
      // if((Jiffy(firstDate).add(days: i).dateTime.isBefore(DateTime.now()))
      while (Jiffy.parseFromDateTime(firstDate)
          .add(days: i)
          .dateTime
          .isBefore(DateTime.now())) {
        List<Posting> postList = AllData.postings
            .where((post) => post.account == null
                ? false
                : (post.account!.id == element.id &&
                    (post.date!.isBefore(Jiffy.parseFromDateTime(firstDate)
                            .add(days: i + 7)
                            .dateTime) &&
                        post.date!.isAfter(Jiffy.parseFromDateTime(firstDate)
                            .add(days: i)
                            .dateTime))))
            .toList();

        postList.sort((pos1, pos2) => pos1.date!.compareTo(pos2.date!));

        List<Transfer> transList = AllData.transfers
            .where((trans) =>
                ((trans.accountFrom != null
                        ? trans.accountFrom!.id == element.id
                        : false) ||
                    (trans.accountTo != null
                        ? trans.accountTo!.id == element.id
                        : false)) &&
                (trans.date!.isBefore(Jiffy.parseFromDateTime(firstDate)
                        .add(days: i + 7)
                        .dateTime) &&
                    trans.date!.isAfter(Jiffy.parseFromDateTime(firstDate)
                        .add(days: i)
                        .dateTime)))
            .toList();

        transList
            .sort((trans1, trans2) => trans1.date!.compareTo(trans2.date!));

        //Berechne neuen Betrag
        postList.forEach((p) {
          if (p.postingType == PostingType.income)
            newAmount += p.amount!;
          else
            newAmount -= p.amount!;
        });

        transList.forEach((t) {
          if (t.accountFrom != null) if (t.accountFrom!.id == element.id)
            newAmount -= t.amount!;
          if (t.accountTo != null) if (t.accountTo!.id == element.id)
            newAmount += t.amount!;
        });

        if (transList.length != 0 || postList.length != 0)
          _chartData.add(_ChartData(
              Jiffy.parseFromDateTime(firstDate).add(days: i).dateTime,
              newAmount));

        i += 7;
      }

      _chartData.add(_ChartData(DateTime.now(), newAmount));
    }

    return _chartData;
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled))
            return Theme.of(context).colorScheme.primary.withValues(alpha: 0.5);
          else
            return Theme.of(context).colorScheme.primary;
        },
      ),
      foregroundColor:
          WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'date-range'.i18n(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Text(
                      '${formatDate(_dateRange.start, context)} - ' +
                          '\n ${formatDate(_dateRange.end, context)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      textAlign: TextAlign.end,
                    ),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: firstAccountCreation,
                        lastDate: DateTime.now(),
                      );

                      if (picked != null)
                        setState(() {
                          _dateRange = picked;
                        });

                      _oneYearIsDisabled = false;
                      _sixMonthsIsDisabled = false;
                      _threeMonthsIsDisabled = false;
                      _oneMonthIsDisabled = false;
                    },
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: firstAccountCreation,
                      lastDate: DateTime.now(),
                    );

                    if (picked != null)
                      setState(() {
                        _dateRange = picked;
                      });

                    _oneYearIsDisabled = false;
                    _sixMonthsIsDisabled = false;
                    _threeMonthsIsDisabled = false;
                    _oneMonthIsDisabled = false;
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          //Divider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Globals.isDarkmode
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    //offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: 400,
              padding: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: DateTimeAxis(
                    autoScrollingMode: AutoScrollingMode.end,
                    minimum: !_oneMonthIsDisabled &&
                            !_sixMonthsIsDisabled &&
                            !_threeMonthsIsDisabled &&
                            !_oneYearIsDisabled
                        ? _dateRange.start
                        : getMondayOfWeek(_dateRange.start),
                    maximum: _dateRange.duration == Duration(days: 0)
                        ? _dateRange.end.add(Duration(days: 1))
                        : _dateRange.end,
                    intervalType: _dateRange.duration > Duration(days: 60)
                        ? DateTimeIntervalType.months
                        : DateTimeIntervalType.days,
                    interval: _dateRange.duration > Duration(days: 60)
                        ? 1
                        : _dateRange.duration > Duration(days: 9)
                            ? 7
                            : 1,
                    dateFormat: _dateRange.duration > Duration(days: 60)
                        ? DateFormat("MMM yy",
                            Localizations.localeOf(context).languageCode)
                        : DateFormat("dd.MMM yy",
                            Localizations.localeOf(context).languageCode),
                    labelRotation: 50,
                    majorTickLines:
                        const MajorTickLines(color: Colors.transparent),
                  ),
                  primaryYAxis: NumericAxis(
                      majorTickLines:
                          const MajorTickLines(color: Colors.transparent),
                      axisLine: const AxisLine(width: 0),
                      numberFormat: currencyNumberFormat()),
                  series: _getDefaultLineSeries(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: Text('one-year'.i18n()),
                          onPressed: _oneYearIsDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _oneYearIsDisabled = true;
                                    _sixMonthsIsDisabled = false;
                                    _threeMonthsIsDisabled = false;
                                    _oneMonthIsDisabled = false;
                                    _dateRange = DateTimeRange(
                                        start: Jiffy.parseFromDateTime(
                                                DateTime.now())
                                            .subtract(years: 1)
                                            .dateTime,
                                        end: DateTime.now());
                                  });
                                },
                          style: buttonStyle,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: Text('six-months'.i18n()),
                          onPressed: _sixMonthsIsDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _oneYearIsDisabled = false;
                                    _sixMonthsIsDisabled = true;
                                    _threeMonthsIsDisabled = false;
                                    _oneMonthIsDisabled = false;
                                    _dateRange = DateTimeRange(
                                        start: Jiffy.parseFromDateTime(
                                                DateTime.now())
                                            .subtract(months: 6)
                                            .dateTime,
                                        end: DateTime.now());
                                  });
                                },
                          style: buttonStyle,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: Text('three-months'.i18n()),
                          onPressed: _threeMonthsIsDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _oneYearIsDisabled = false;
                                    _sixMonthsIsDisabled = false;
                                    _threeMonthsIsDisabled = true;
                                    _oneMonthIsDisabled = false;
                                    _dateRange = DateTimeRange(
                                        start: Jiffy.parseFromDateTime(
                                                DateTime.now())
                                            .subtract(months: 3)
                                            .dateTime,
                                        end: DateTime.now());
                                  });
                                },
                          style: buttonStyle,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: Text('one-month'.i18n()),
                          onPressed: _oneMonthIsDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _oneYearIsDisabled = false;
                                    _sixMonthsIsDisabled = false;
                                    _threeMonthsIsDisabled = false;
                                    _oneMonthIsDisabled = true;
                                    _dateRange = DateTimeRange(
                                        start: Jiffy.parseFromDateTime(
                                                DateTime.now())
                                            .subtract(months: 1)
                                            .dateTime,
                                        end: DateTime.now());
                                  });
                                },
                          style: buttonStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries() {
    return AllData.accounts.map((e) {
      List<_ChartData> _dataSource = _getChartData(e);

      return LineSeries<_ChartData, DateTime>(
          dataSource: _dataSource,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          name: e.title);
    }).toList();
  }
}

double _getFirstBankBalance(Account ac) {
  double amount = ac.bankBalance!;

  AllData.postings
      .where((element) =>
          element.account == null ? false : element.account!.id == ac.id)
      .forEach((posting) {
    if (posting.postingType == PostingType.income) amount -= posting.amount!;
    if (posting.postingType == PostingType.expense) amount += posting.amount!;
  });

  AllData.transfers
      .where((element) => element.accountFrom == null
          ? false
          : element.accountFrom!.id == ac.id)
      .forEach((tr) {
    amount += tr.amount!;
  });

  AllData.transfers
      .where((element) =>
          element.accountTo == null ? false : element.accountTo!.id == ac.id)
      .forEach((tr) {
    amount -= tr.amount!;
  });

  return amount;
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
