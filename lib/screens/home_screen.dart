import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

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
  String _selectedCategoryID = '';

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
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: ElevatedButton(
          child: Text('Kategorie ändern'),
          // style: ButtonStyle(
          //     backgroundColor:
          //         MaterialStateProperty.all(Theme.of(context).primaryColor)),
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Popup(
                      title: 'Kategorien',
                      body: Container(
                        //color: Colors.blue,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        height: MediaQuery.of(context).size.height * 0.48,
                        width: MediaQuery.of(context).size.width * 1,
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.5),
                          padding: EdgeInsets.all(10),
                          crossAxisCount: 3,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * 0.04,
                          mainAxisSpacing: 12,
                          children: AllData.categories
                              .map((item) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _selectedCategoryID = '${item.id}';
                                        }),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius:
                                                      _selectedCategoryID ==
                                                              '${item.id}'
                                                          ? 5
                                                          : 5,
                                                  color: _selectedCategoryID ==
                                                          '${item.id}'
                                                      ? item.color!
                                                          .withOpacity(0.2)
                                                      : item.color!
                                                          .withOpacity(0.05),
                                                  spreadRadius:
                                                      _selectedCategoryID ==
                                                              '${item.id}'
                                                          ? 2
                                                          : 1,
                                                )
                                              ],
                                            ),
                                            // width: 60,
                                            // height: 60,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Image.asset(item.symbol!,
                                                  color: item.color!),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        // child: SingleChildScrollView( //---> Alternative zu den drei Punkten
                                        //   scrollDirection: Axis.horizontal,
                                        child: Text(
                                          '${item.title}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: item.color),
                                          textAlign: TextAlign.center,
                                        ),
                                        // ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                      saveButton: false,
                      cancelButton: true);
                });
              }),
        ),
      ),
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
    );
    // ignore: todo
    //TODO: Cupertino Design
  }
}
