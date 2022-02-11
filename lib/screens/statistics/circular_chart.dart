import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/statistics/expense_circular_chart.dart';
import 'package:haushaltsbuch/screens/statistics/income_circular_chart.dart';

class CircularChart extends StatefulWidget {
  const CircularChart({Key? key}) : super(key: key);

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TabBar(
      tabs: [
        Tab(text: 'Ausgabe'),
        Tab(text: 'Einnahme'),
      ],
      controller: _tabController,
    ), Expanded(
      child: TabBarView(
        children: [
          ExpenseCircularChart(),
          IncomeCircularChart(),
        ],
        controller: _tabController,
      ),
    ),
    ],);
  }
}
