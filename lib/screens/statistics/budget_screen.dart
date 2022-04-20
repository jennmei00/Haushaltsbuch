import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({ Key? key }) : super(key: key);
  static final routeName = '/budget_screen';

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Budget'),
          centerTitle: true,
        ),
        drawer: AppDrawer(selectedMenuItem: 'budget'),
        body: Container(),
    );
  }
}