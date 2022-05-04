import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/statistics/month_overview.dart';
import 'package:haushaltsbuch/screens/statistics/line_chart.dart';
import 'package:haushaltsbuch/screens/statistics/year_overview_table.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:localization/localization.dart';

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
          title: Text('statistic'.i18n()),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'asset-overview'.i18n()),
              Tab(text: 'month-overview'.i18n()),
              Tab(text: 'year-overview'.i18n()),
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
