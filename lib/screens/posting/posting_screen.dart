import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:localization/localization.dart';

class PostingScreen extends StatelessWidget {
  static final routeName = '/posting_screen';

  @override
  Widget build(BuildContext context) {
    ImageProvider einnahmeImage = AssetImage("assets/images/einnahme.jpg");
    ImageProvider ausgabe2Image = AssetImage("assets/images/ausgabe2.jpg");
    ImageProvider umbuchungImage = AssetImage("assets/images/umbuchung.jpg");

    return Scaffold(
      appBar: AppBar(
        title: Text('posting'.i18n()),
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
                      image: einnahmeImage,
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
                        'income'.i18n(),
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
                      image: ausgabe2Image,
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
                        'expense'.i18n(),
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
                      image: umbuchungImage,
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
                        'transfer'.i18n(),
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
  }

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
