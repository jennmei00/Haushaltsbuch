import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class PostingScreen extends StatelessWidget {
  static final routeName = '/posting_screen';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Buchen'),
          centerTitle: true,
        ),
        drawer: AppDrawer(
          selectedMenuItem: 'posting',
        ),
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/einnahme.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          'Einnahme',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _expense(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/ausgabe2.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.money_off,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          'Ausgabe',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _transfer(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/umbuchung.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.compare_arrows,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text(
                          'Umbuchung',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
        .pushNamed(IncomeExpenseScreen.routeName, arguments: ['Einnahme', '']);
  }

  void _expense(BuildContext context) {
    Navigator.of(context)
        .pushNamed(IncomeExpenseScreen.routeName, arguments: ['Ausgabe', '']);
  }

  void _transfer(BuildContext context) {
    Navigator.of(context).pushNamed(TransferScreen.routeName, arguments: '');
  }
}
