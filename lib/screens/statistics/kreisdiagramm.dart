import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;

class Kreisdiagramm extends StatefulWidget {
  const Kreisdiagramm({Key? key}) : super(key: key);

  @override
  State<Kreisdiagramm> createState() => _KreisdiagrammState();
}

class _KreisdiagrammState extends State<Kreisdiagramm> {
  DateTime _yearValue = DateTime.now();
  DateTime _monthValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              right: 5.0, left: 5.0, bottom: 8.0, top: 20.0),
          child: Column(children: [
            Text('Jahr'),
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
              height: 20,
            ),
            Text('Monat'),
            slider.SfSlider(
              min: DateTime(2000, 01, 01),
              max: DateTime(2000, 12, 01),
              showLabels: true,
              interval: 1,
              stepDuration: const slider.SliderStepDuration(months: 1),
              dateFormat: DateFormat.M("de"),
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
                return DateFormat.MMMM("de").format(actualLabel);
              },
            ),
          ]),
        ),
        SfCircularChart(
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: _getPieSeries(),
        ),
      ],
    );
  }

  List<_ChartData> _getDatasource() {
    List<_ChartData> source = [];

    AllData.categories.forEach((element) {
      double amount = 0;

      AllData.postings
          .where((p) => p.category!.id == element.id)
          .forEach((posting) {
        if (posting.postingType == PostingType.expense) {
          if (posting.date!.year == _yearValue.year &&
              posting.date!.month == _monthValue.month)
            amount += posting.amount!;
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
        explode: true,
        explodeIndex: 0,
        explodeOffset: '10%',
        dataSource: _getDatasource(),
        xValueMapper: (_ChartData data, _) => data.x,
        yValueMapper: (_ChartData data, _) => data.y,
        dataLabelMapper: (_ChartData data, _) => data.text,
        // startAngle: 90,
        // endAngle: 90,
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
