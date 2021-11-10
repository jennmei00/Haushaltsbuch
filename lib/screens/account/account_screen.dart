import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/account/new_account_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class AccountScreen extends StatefulWidget {
  static final routeName = '/account_screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var accountTypeList = [];
  var accountData = AllData.accounts;
  void _createAccountList() {
    for (var i = 0; i < accountData.length; i++) {
      print(accountData[i].title);
      if (!accountTypeList.contains(accountData[i].accountType!.title)) {
        accountTypeList.add(accountData[i].accountType!.title);
      }
    }
    print(accountTypeList);
  }

  @override
  void initState() {
    _createAccountList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[200],
          child: Icon(Icons.add),
          onPressed: () {
            //print(accountData);
            Navigator.of(context).pushNamed(NewAccountScreen.routeName);
          },
        ),
        appBar: AppBar(
            title: Text('Konten'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        drawer: AppDrawer(),
        body: AllData.accounts.length == 0
            ? Text('Kein Konto vorhanden, erstelle welche!')
            : Padding(
                padding: const EdgeInsets.all(30),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Vermögen:\n10.000€',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: accountTypeList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              //height: 50,
                              // child: Center(
                              //     child: Text('Entry ${accountTypeList[index]}')),
                            );
                          },
                        ),
                        // child: ListView(
                        //   shrinkWrap: true,
                        //   children: [
                        //     Card(
                        //       child: ExpansionTile(
                        //         initiallyExpanded: false,
                        //         title: Text('Kontokategorie 1'),
                        //         children: [
                        //           Card(
                        //             margin: EdgeInsets.all(10),
                        //             color: Colors.lightBlue,
                        //             child: ListTile(
                        //               title: Text('Test'),
                        //             ),
                        //           ),
                        //           Card(
                        //             margin: EdgeInsets.all(10),
                        //             color: Colors.lightBlue,
                        //             child: ListTile(
                        //               title: Text('Test 2'),
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
