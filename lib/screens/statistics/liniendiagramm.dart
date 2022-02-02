import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Liniendiagramm extends StatefulWidget {
  const Liniendiagramm({Key? key}) : super(key: key);

  @override
  State<Liniendiagramm> createState() => _LiniendiagrammState();
}

class _LiniendiagrammState extends State<Liniendiagramm> {
  List<_ChartData> _chartData = [];
  bool isLoading = true;

  void _loadData() {
    _chartData = <_ChartData>[];

    Account element = AllData.accounts.firstWhere((element) => element.title == 'Test1');

    // AllData.accounts.forEach((element) {
    var firstDate;

    switch (Jiffy(element.creationDate).day) {
      case 1:
        firstDate = Jiffy(element.creationDate).subtract(days: 6).dateTime;
        break;
      case 2:
        firstDate = element.creationDate;
        break;
      case 3:
        firstDate = Jiffy(element.creationDate).subtract(days: 1).dateTime;

        break;
      case 4:
        firstDate = Jiffy(element.creationDate).subtract(days: 2).dateTime;

        break;
      case 5:
        firstDate = Jiffy(element.creationDate).subtract(days: 3).dateTime;

        break;
      case 6:
        firstDate = Jiffy(element.creationDate).subtract(days: 4).dateTime;

        break;
      case 7:
        firstDate = Jiffy(element.creationDate).subtract(days: 5).dateTime;

        break;
      default:
    }

    firstDate = DateTime(2021, 11, 1);
    _chartData.add(_ChartData(firstDate, element.initialBankBalance!, 0));

    int i = 7;
    double newAmount = element.initialBankBalance!;
    while (Jiffy(firstDate).add(days: i).dateTime.isBefore(DateTime.now())) {
      List<Posting> postList = AllData.postings
          .where((post) =>
              post.account!.id == element.id &&
              (post.date!
                      .isBefore(Jiffy(firstDate).add(days: i + 7).dateTime) &&
                  post.date!.isAfter(Jiffy(firstDate).add(days: i).dateTime)))
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

      transList.sort((trans1, trans2) => trans1.date!.compareTo(trans2.date!));

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
            Jiffy(firstDate).add(days: i).dateTime, newAmount, 4000));

      i += 7;
    }

    //  var firstDate =  Jiffy(element.creationDate).subtract(
    //     Jiffy(element.creationDate).day != 2 ? 0
    //   ).dateTime;
    // });

    
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getChartData();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            // DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
            DateTimeAxis(
          minimum: DateTime.now().subtract(Duration(days: 90)),
          maximum: DateTime.now(),
          intervalType: DateTimeIntervalType.days,
          interval: 7,
          dateFormat: DateFormat.yMMMd()
        ),
        primaryYAxis: NumericAxis(
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          axisLine: const AxisLine(width: 0),
          // minimum: 0,
          // maximum: 100
        ),
        series: _getDefaultLineSeries(),
      ),
    );
  }

  void _getChartData() {
    _chartData = <_ChartData>[];

    //From first account
    // Account account = AllData.accounts.first;
    // double

    // AllData.postings.forEach((element) {
    //   _chartData.add(_ChartData(element.date!, element.amount!));
    // });

    // AllData.transfers.forEach((element) {
    //   _chartData.add(_ChartData(element.date!, element.amount!));
    // });
  }

  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
          dataSource: _chartData,
          xValueMapper: (_ChartData time, _) => time.x,
          yValueMapper: (_ChartData money, _) => money.y,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final DateTime x;
  final double y;
  final double y2;
}
