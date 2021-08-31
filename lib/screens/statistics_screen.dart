import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  static final routeName = '/statistics_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Statistik'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
  );
}