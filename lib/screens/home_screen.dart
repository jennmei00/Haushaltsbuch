import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

import 'categories/new_categorie_screen.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/home_screen';

  //wieder loeschen
  final String id;
  HomeScreen({this.id = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String value = 'Dein Vermögen beträgt';
  bool showsBalance = false;

  var accountData = AllData.accounts;

  double totalBankBalance = 0;

  //wieder loeschen
  String _selectedIcon = '';

  void _getTotalBankBalance() {
    accountData.forEach((ac) {
      totalBankBalance += ac.bankBalance!;
    });
    totalBankBalance = double.parse((totalBankBalance).toStringAsFixed(2));
  }

  final List<Category> _categoryList = AllData.categories; //Test

  @override
  void initState() {
    _getTotalBankBalance();
    //wieder loeschen
    if (widget.id != '') {
      Category cat = AllData.categories
          as Category; //.firstWhere((element) => element.id == widget.id);
      _selectedIcon = cat.symbol == null ? '' : cat.symbol!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),

        // drawer: Drawer(),
        drawer: AppDrawer(),
        body: AllData.categories.length == 0
            ? NothingThere(textScreen: 'Noch keine Kategorien vorhanden :(')
            : GridView.count(
                scrollDirection: Axis.vertical,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.9),
                padding: EdgeInsets.all(20),
                crossAxisCount: 3,
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                mainAxisSpacing: 12,
                children: _categoryList
                    .map((item) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: item.color!.withOpacity(0.1),
                                spreadRadius: 2,
                              )
                            ],
                            // color: _selectedIcon == item;
                            //       ? Theme.of(context).primaryColor
                            //       : Colors.grey.shade700,
                            color: item.color!.withOpacity(0.05),
                          ),
                          child: InkWell(
                            //Idee: transparente Farbe des Icons wenn ausgewählt
                            borderRadius: BorderRadius.circular(8),
                            // onTap: () => setState(() {
                            //   _selectedIcon = item;
                            // }),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(item.symbol!,
                                        color: item.color!),
                                  ),
                                  SizedBox(height: 4),
                                  Center(
                                      child: Text(
                                    '${item.title}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: item.color),
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                // body: Center(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       boxShadow: [
                //         BoxShadow(
                //           blurRadius: 20,
                //           color: Theme.of(context).primaryColor,
                //           spreadRadius: 10,
                //         )
                //       ],
                //     ),
                //     child: GestureDetector(
                //       onTap: () {
                //         if (!showsBalance) {
                //           setState(() {
                //             value = totalBankBalance.toString() + ' €';
                //             showsBalance = true;
                //           });
                //         } else {
                //           setState(() {
                //             value = 'Dein Vermögen beträgt';
                //             showsBalance = false;
                //           });
                //         }
                //       },
                //       child: CircleAvatar(
                //         radius: 150,
                //         backgroundColor: Theme.of(context).primaryColor,
                //         child: Text(
                //           value,
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontFamily: 'Handwritingstyle',
                //               fontSize: 50,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ));

    // ignore: todo
    //TODO: Cupertino Design
  }
}
