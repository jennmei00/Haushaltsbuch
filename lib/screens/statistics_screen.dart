import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class StatisticsScreen extends StatelessWidget {
  static final routeName = '/statistics_screen';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Statistik'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(),
      );
}
