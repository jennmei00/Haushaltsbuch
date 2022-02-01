import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Liniendiagramm extends StatefulWidget {
  const Liniendiagramm({Key? key}) : super(key: key);

  @override
  State<Liniendiagramm> createState() => _LiniendiagrammState();
}

class _LiniendiagrammState extends State<Liniendiagramm> {
  List<_ChartData> _chartData = [];

  @override
  Widget build(BuildContext context) {
    _getChartData();

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis:
          // DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
          DateTimeAxis(),
          
      primaryYAxis: NumericAxis(
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          axisLine: const AxisLine(width: 0),
          // minimum: 0,
          // maximum: 100
          ),
      series: _getDefaultLineSeries(),
    );
  }

  void _getChartData() {
    _chartData = <_ChartData>[];

    //From first account
    Account account = AllData.accounts.first;
    // double
   

    AllData.postings.forEach((element) {
      _chartData.add(_ChartData(element.date!, element.amount!));
    });

    AllData.transfers.forEach((element) {
      _chartData.add(_ChartData(element.date!, element.amount!));
    });
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
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
