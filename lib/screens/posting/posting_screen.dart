import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/posting/income_expenses_screen.dart';
import 'package:haushaltsbuch/screens/posting/transfer_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class PostingScreen extends StatelessWidget {
  static final routeName = '/posting_screen';
  final urlBackgroundImageIncome =
      'https://images.unsplash.com/photo-1579621970795-87facc2f976d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80';

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
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    //height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(urlBackgroundImageIncome),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text('Einnahme'),
                    // child: Padding(
                    //   padding: const EdgeInsets.all(30),
                    // child: FractionallySizedBox(
                    //   widthFactor: 1,
                    //     child: OutlinedButton(
                    //       onPressed: () {
                    //         _income(context);
                    //       },
                    //       child: Text('Einnahme'),
                    //       style: ButtonStyle(
                    //         shape:
                    //             MaterialStateProperty.all<RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(18.0),
                    //           ),
                    //         // ),
                    //       // ),
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        _expense(context);
                      },
                      child: Text('Ausgabe'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        _transfer(context);
                      },
                      child: Text('Umbuchung'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
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
