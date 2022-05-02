import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/statistics/month_overview.dart';
import 'package:haushaltsbuch/screens/statistics/line_chart.dart';
import 'package:haushaltsbuch/screens/statistics/year_overview_table.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistik'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Vermögensübersicht'),
              Tab(text: 'Monatsübersicht'),
              Tab(text: 'Jahresübersicht'),
            ],
            controller: _tabController,
          ),
        ),
        drawer: AppDrawer(
          selectedMenuItem: 'statistic',
        ),
        body: TabBarView(
          children: [
            LineChart(),
            CircularChart(),
            YearOverviewTable(),
          ],
          controller: _tabController,
        ));
  }
}
