import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  DateTimeRange _dateRange = DateTimeRange(
      start: Jiffy(DateTime.now()).subtract(months: 3).dateTime,
      end: DateTime.now());

  DateTime firstAccountCreation = DateTime.now();

  List<_ChartData> _getChartData(Account element) {
    List<_ChartData> _chartData = <_ChartData>[];

    if (element.creationDate!.isBefore(firstAccountCreation))
      firstAccountCreation = element.creationDate!;

    var firstDate;

    firstDate = getMondayOfWeek(element.creationDate!);

    // firstDate = DateTime(2021, 11, 1);
    _chartData.add(_ChartData(
      firstDate,
      element.initialBankBalance!,
    ));

    if (AllData.postings
            .where((val) =>
                val.account == null ? false : val.account!.id == element.id)
            .length ==
        0) {
      _chartData.add(_ChartData(DateTime.now(), element.initialBankBalance!));
    } else {
      int i = 7;
      double newAmount = element.initialBankBalance!;
      while (Jiffy(firstDate).add(days: i).dateTime.isBefore(DateTime.now())) {
        List<Posting> postList = AllData.postings
            .where((post) => post.account == null
                ? false
                : (post.account!.id == element.id &&
                    (post.date!.isBefore(
                            Jiffy(firstDate).add(days: i + 7).dateTime) &&
                        post.date!
                            .isAfter(Jiffy(firstDate).add(days: i).dateTime))))
            .toList();

        postList.sort((pos1, pos2) => pos1.date!.compareTo(pos2.date!));

        List<Transfer> transList = AllData.transfers
            .where((trans) =>
                (trans.accountFrom != null
                    ? trans.accountFrom!.id == element.id
                    : false) ||
                (trans.accountTo != null
                        ? trans.accountTo!.id == element.id
                        : false) &&
                    (trans.date!.isBefore(
                            Jiffy(firstDate).add(days: i + 7).dateTime) &&
                        trans.date!
                            .isAfter(Jiffy(firstDate).add(days: i).dateTime)))
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
          _chartData.add(
              _ChartData(Jiffy(firstDate).add(days: i).dateTime, newAmount));

        i += 7;
      }

      _chartData.add(_ChartData(DateTime.now(), newAmount));
    }

    return _chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Zeitraum',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Text(
                '${formatDate(_dateRange.start)} - ' +
                    '\n ${formatDate(_dateRange.end)}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                textAlign: TextAlign.end,
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
              },
              icon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Divider(),
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),

            primaryXAxis: DateTimeAxis(
              autoScrollingMode: AutoScrollingMode.end,
              minimum: getMondayOfWeek(_dateRange.start),
              maximum: _dateRange.end,
              intervalType: DateTimeIntervalType.days,
              interval: 7,
              dateFormat: weeklyDateFormat(),
              majorTickLines: const MajorTickLines(color: Colors.transparent),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              axisLine: const AxisLine(width: 0),
              numberFormat: NumberFormat.currency(locale: "de", symbol: "€"),
              // minimum: 0,
              // maximum: 100
            ),
            series: _getDefaultLineSeries(),
            // ),
          ),
        ),
      ],
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

    //  <LineSeries<_ChartData, DateTime>>[
    //   LineSeries<_ChartData, DateTime>(
    //       dataSource: _chartData,
    //       xValueMapper: (_ChartData data, _) => data.x,
    //       yValueMapper: (_ChartData data, _) => data.y,
    //       markerSettings: const MarkerSettings(isVisible: true))
    // ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
