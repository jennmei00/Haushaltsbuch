import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
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
  Widget build(BuildContext context){
    

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
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Theme.of(context).primaryColor,
                spreadRadius: 10,
              )
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (!showsBalance) {
                setState(() {
                  value = totalBankBalance.toString() + ' €';
                  showsBalance = true;
                });
              } else {
                setState(() {
                  value = 'Dein Vermögen beträgt';
                  showsBalance = false;
                });
              }
            },
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Handwritingstyle',
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
    // ignore: todo
    //TODO: Cupertino Design
  }
}
