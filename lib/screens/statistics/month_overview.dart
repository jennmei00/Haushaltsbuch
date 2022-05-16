import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/statistics/expense_circular_chart.dart';
import 'package:haushaltsbuch/screens/statistics/income_circular_chart.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:localization/localization.dart';

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
    return Column(
      children: [
        Container(
          //color: Theme.of(context).primaryColor.withOpacity(0.1),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Globals.isDarkmode
                    ? Colors.black.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                //offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TabBar(
            labelColor: Globals.isDarkmode ? null : Colors.black,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'expenses'.i18n()),
              Tab(text: 'incomes'.i18n()),
            ],
            controller: _tabController,
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              ExpenseCircularChart(),
              IncomeCircularChart(),
            ],
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}
