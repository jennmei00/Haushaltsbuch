import 'package:flutter/material.dart';

class StandingOrdersScreen extends StatelessWidget {
  static final routeName = '/standing_orders_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Daueraufträge'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
  );
}