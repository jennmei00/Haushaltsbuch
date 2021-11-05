import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class PostingScreen extends StatelessWidget {
  static final routeName = '/posting_screen';
  final urlBackgroundImageIncome =
      'https://images.unsplash.com/photo-1579621970795-87facc2f976d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80';
  final urlBackgroundImageExpense = 'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1612&q=80';
  final urlBackroundImageTransfer = 'https://images.unsplash.com/photo-1523629619140-ee5b56cb3b23?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=3114&q=80';
  
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Buchen'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(),
        body: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _income(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.all(25),
                    width: double.infinity,
                    //height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(urlBackgroundImageIncome),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Einnahme',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _income(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.all(25),
                    width: double.infinity,
                    //height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(urlBackgroundImageExpense),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Ausgabe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _income(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.all(25),
                    width: double.infinity,
                    //height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(urlBackroundImageTransfer),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Umbuchung',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      );

  void _income(BuildContext context) {
    Navigator.of(context)
        .pushNamed(IncomeExpenseScreen.routeName, arguments: 'Einnahme');
  }

  void _expense(BuildContext context) {
    Navigator.of(context)
        .pushNamed(IncomeExpenseScreen.routeName, arguments: 'Asugabe');
  }

  void _transfer(BuildContext context) {
    Navigator.of(context).pushNamed(TransferScreen.routeName);
  }
}
