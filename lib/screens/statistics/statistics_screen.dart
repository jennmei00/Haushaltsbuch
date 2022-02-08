import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/statistics/circular_chart.dart';
import 'package:haushaltsbuch/screens/statistics/line_chart.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class StatisticsScreen extends StatefulWidget {
  static final routeName = '/statistics_screen';

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Statistik'),
        centerTitle: true,
        bottom: TabBar(
          tabs: [
            Tab(text: 'Liniendiagramm'),
            Tab(text: 'Kreisdiagramm'),
          ],
          controller: _tabController,
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        children: [
          LineChart(),
          CircularChart(),
        ],
        controller: _tabController,
      )
      //Initialize the chart widget

      // SfCartesianChart(
      //     primaryXAxis: CategoryAxis(),
      //     // Chart title
      //     title: ChartTitle(text: 'Half yearly sales analysis'),
      //     // Enable legend
      //     legend: Legend(isVisible: true),
      //     // Enable tooltip
      //     tooltipBehavior: TooltipBehavior(enable: true),
      //     series: <ChartSeries<_SalesData, String>>[
      //       LineSeries<_SalesData, String>(
      //           dataSource: data,
      //           xValueMapper: (_SalesData sales, _) => sales.year,
      //           yValueMapper: (_SalesData sales, _) => sales.sales,
      //           name: 'Sales',
      //           // Enable data label
      //           dataLabelSettings: DataLabelSettings(isVisible: true)),
      //     ]),
      // Expanded(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     //Initialize the spark charts widget
      //     child: SfSparkLineChart.custom(
      //       //Enable the trackball
      //       trackball: SparkChartTrackball(
      //           activationMode: SparkChartActivationMode.tap),
      //       //Enable marker
      //       marker: SparkChartMarker(
      //           displayMode: SparkChartMarkerDisplayMode.all),
      //       //Enable data label
      //       labelDisplayMode: SparkChartLabelDisplayMode.all,
      //       xValueMapper: (int index) => data[index].year,
      //       yValueMapper: (int index) => data[index].sales,
      //       dataCount: 5,
      //     ),
      //   ),
      // )
      );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
