import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/budget/new_budget_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);
  static final routeName = '/budget_screen';

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(NewBudgetScreen.routeName, arguments: '');
        },
      ),
      appBar: AppBar(
        title: Text('Budget'),
        centerTitle: true,
      ),
      drawer: AppDrawer(selectedMenuItem: 'budget'),
      body: Container(
        
      ),
    );
  }
}
