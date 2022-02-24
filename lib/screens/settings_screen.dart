import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:haushaltsbuch/services/theme_notifier.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  static final routeName = '/settings_screen';
  bool _darkTheme = false;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
    Globals.isDarkmode = value;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
        centerTitle: true,
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SwitchListTile(
            secondary: Icon(Icons.lightbulb),
            title: Text('Darkmode'),
            // subtitle: Text(''),
            value: _darkTheme,
            onChanged: (val) {
              onThemeChanged(val, themeNotifier);
            },
          ),
          //
          //
          //  more settings
          //
          //
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: TextButton(
              child: Text('Alle Daten Löschen'),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Alle Daten löschen"),
                      content: const Text(
                          "Bist du WIRKLICH sicher, dass du ALLE Daten löschen willst?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              await DBHelper.deleteDatabse();

                              Navigator.of(context).pop(true);
                              Phoenix.rebirth(context);
                            },
                            child: const Text("Löschen")),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Abbrechen"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.playlist_add,
              color: Colors.green,
            ),
            title: TextButton(
              child: Text('Dummy Daten hinzufügen'),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                foregroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Hinzufügen?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              //DummyDaten
                              //Accounts
                              // List<Account> accounts = [
                              //   Account(
                              //     accountType: AllData.accountTypes.firstWhere(
                              //         (element) =>
                              //             element.title == 'Kreditkartenkonto'),
                              //     bankBalance: 1700,
                              //     color: Color(0xff4527a0),
                              //     creationDate: DateTime(2021, 15, 02),
                              //     description: 'VISA-Card von Tomorrow',
                              //     id: Uuid().v1(),
                              //     initialBankBalance: 1700,
                              //   )
                              // ];
                              List<StandingOrder> soList = [
                                // StandingOrder(
                                //     id: Uuid().v1(),
                                //     account: AllData.accounts.firstWhere(
                                //         (element) =>
                                //             element.title == 'Sparkasse'),
                                //     amount: 240,
                                //     begin: DateTime(2021, 12, 30),
                                //     category: AllData.categories.firstWhere(
                                //       (element) => element.title == 'Auto',
                                //     ),
                                //     description: 'Auto Leasing',
                                //     postingType: PostingType.expense,
                                //     repetition: Repetition.monthly,
                                //     title: 'Leasing'),
                                // StandingOrder(
                                //     id: Uuid().v1(),
                                //     account: AllData.accounts.firstWhere(
                                //         (element) =>
                                //             element.title == 'Tomorrow'),
                                //     amount: 50,
                                //     begin: DateTime(2022, 01, 15),
                                //     category: AllData.categories.firstWhere(
                                //       (element) =>
                                //           element.title == 'Handyvertrag',
                                //     ),
                                //     description:
                                //         'Test für Handyvertrag --- Dauerauftraaag.',
                                //     postingType: PostingType.expense,
                                //     repetition: Repetition.weekly,
                                //     title: 'Handyvertrag'),
                              ];

                              soList.forEach((element) {
                                DBHelper.insert(
                                    'StandingOrder', element.toMap());
                                AllData.standingOrders.add(element);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Add")),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Abbrechen"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
