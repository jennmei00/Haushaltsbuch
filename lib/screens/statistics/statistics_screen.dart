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
      drawer: AppDrawer(selectedMenuItem: 'statistic',),
      body: TabBarView(
        children: [
          LineChart(),
          CircularChart(),
        ],
        controller: _tabController,
      )
      );
}
