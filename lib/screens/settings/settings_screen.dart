import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:haushaltsbuch/models/account.dart';
// import 'package:haushaltsbuch/models/all_data.dart';
// import 'package:haushaltsbuch/models/enums.dart';
// import 'package:haushaltsbuch/models/posting.dart';
// import 'package:haushaltsbuch/models/standing_order.dart';
// import 'package:haushaltsbuch/models/transfer.dart';
// import 'package:uuid/uuid.dart';
import 'package:haushaltsbuch/screens/settings/credits_screen.dart';
import 'package:haushaltsbuch/screens/settings/excel_export.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/theme.dart';
import 'package:haushaltsbuch/services/theme_notifier.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:localization/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SettingsScreen extends StatefulWidget {
  static final routeName = '/settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = false;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
    Globals.isDarkmode = value;
  }

  Future<File> _writeDBFileToDownloadFolder() async {
    String dbName = "Haushaltsbuch.db";
    String? downloadPath = await FileHelper().getDownloadPath();
    final dbPath = await getDatabasesPath();

    var dbFile = File('$dbPath/$dbName');
    var filePath = downloadPath! + '/$dbName';
    var dbFileBytes = dbFile.readAsBytesSync();
    var bytes = ByteData.view(dbFileBytes.buffer);
    final buffer = bytes.buffer;

    return File(filePath).writeAsBytes(buffer.asUint8List(
        dbFileBytes.offsetInBytes, dbFileBytes.lengthInBytes));
  }

  Future<void> _writeExternFileToDBFolder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.path.endsWith('Haushaltsbuch.db')) {
        final dbPath = await getDatabasesPath() + '/Haushaltsbuch.db';
        var dbFileBytes = file.readAsBytesSync();
        var bytes = ByteData.view(dbFileBytes.buffer);
        final buffer = bytes.buffer;
        File(dbPath).writeAsBytes(buffer.asUint8List(
            dbFileBytes.offsetInBytes, dbFileBytes.lengthInBytes));

        Phoenix.rebirth(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('invalid-file'.i18n())));
      }
    } else {
      //canceld pick
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.i18n()),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SwitchListTile(
            secondary: Icon(Icons.lightbulb),
            title: Text('darkmode'.i18n()),
            value: _darkTheme,
            onChanged: (val) {
              onThemeChanged(val, themeNotifier);
            },
          ),
          GestureDetector(
            child: ListTile(
              // leading: Icon(Icons.euro),
              leading: Text(
                Globals.currency.symbol,
                style: TextStyle(fontSize: 30, color: Colors.grey),
              ),
              title: Text(
                'currency'.i18n(),
              ),
            ),
            onTap: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                onSelect: (Currency currency) {
                  setState(() {
                    Globals.currency = currency;
                    FileHelper().writeCurrency(currency);
                  });
                },
              );
            },
          ),
          // Excel Export
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.table_chart_outlined),
              title: Text('Excel Export'),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ExcelExport.routeName);
            },
          ),
          // GestureDetector(
          //   child: ListTile(
          //     leading: Icon(Icons.slideshow),
          //     title: Text('Tutorial abspielen'),
          //   ),
          //   onTap: () {
          //     // showTutorial();
          //   },
          // ),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.download),
              title: Text('export-import-data'.i18n()),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('export-import-data'.i18n()),
                    content: Text('export-import-data-text'.i18n()),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            var status = await Permission.storage.status;
                            if (status.isDenied) {
                              await Permission.storage.request();
                              return;
                            }

                            File file = await _writeDBFileToDownloadFolder();
                            if (await file.length() > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('save-database'.i18n())));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'couldnt-save-database'.i18n())));
                            }

                            Navigator.of(context).pop(true);
                          },
                          child: Text('export'.i18n())),
                      TextButton(
                          onPressed: () async {
                            _writeExternFileToDBFolder();

                            Navigator.of(context).pop(true);
                          },
                          child: Text('import'.i18n())),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("cancel".i18n()),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.support_agent),
              title: Text(
                'send-to-support'.i18n(),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("send-mail".i18n()),
                    content: Text("send-mail-text".i18n()),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            final directory =
                                await getApplicationSupportDirectory();

                            // FileHelper().writeAppLog(
                            //     AppLog('Test', 'Upgrade Tables Version 2'));
                            if (File('${directory.path}/AppLog.log')
                                .existsSync()) {
                              if (File('${directory.path}/AppLog.log')
                                      .readAsStringSync() !=
                                  '') {
                                final Email email = Email(
                                  body:
                                      'Im Anhang die entsprechende AppLog Datei.',
                                  subject: 'AppLog',
                                  recipients: ['jstudios0096@gmail.com'],
                                  attachmentPaths: [
                                    '${directory.path}/AppLog.log'
                                  ],
                                  isHTML: false,
                                );
                                try {
                                  await FlutterEmailSender.send(email);
                                } catch (ex) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'couldnt-sent-mail'.i18n())));
                                }
                              } else {
                                //File is empty
                              }
                            } else {
                              //File dousnt exist
                            }

                            Navigator.of(context).pop(true);
                          },
                          child: Text("send".i18n())),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("cancel".i18n()),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.my_library_books),
              title: Text(
                'credits'.i18n(),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(Credits.routeName);
            },
          ),
          GestureDetector(
              child: ListTile(
                leading: Icon(
                  Icons.description,
                ),
                title: Text('licenses'.i18n()),
              ),
              onTap: () => showLicensePage(
                  context: context,
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 48,
                    ),
                  ),
                  applicationName: 'Haushaltsbuch',
                  applicationVersion: '${Globals.version}'
                  //  '1.0.0',
                  // applicationLegalese: 'Copyright My Company'
                  )),
          // GestureDetector(
          //   child: ListTile(
          //     leading: Icon(
          //       Icons.description,
          //     ),
          //     title: Text('Impressum'),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(Imprint.routeName);
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: TextButton(
              child: Text('delete-all-data'.i18n()),
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
                      title: Text("delete-all-data".i18n()),
                      content: Text("delete-all-data-text".i18n()),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              await DBHelper.deleteDatabse();

                              Navigator.of(context).pop(true);
                              Phoenix.rebirth(context);
                            },
                            child: Text("delete".i18n())),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("cancel".i18n()),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.playlist_add,
          //     color: Colors.green,
          //   ),
          //   title: TextButton(
          //     child: Text('Dummy Daten hinzufügen'),
          //     style: ButtonStyle(
          //       alignment: Alignment.centerLeft,
          //       padding: MaterialStateProperty.all(EdgeInsets.zero),
          //       foregroundColor: MaterialStateProperty.all(Colors.green),
          //     ),
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             title: const Text("Hinzufügen?"),
          //             actions: <Widget>[
          //               TextButton(
          //                   onPressed: () async {
          //                     //DummyDaten
          //                     // Accounts
          //                     List<Account> accounts = [
          //                       Account(
          //                           accountType: AllData.accountTypes
          //                               .firstWhere((element) =>
          //                                   element.title ==
          //                                   'Kreditkartenkonto'),
          //                           bankBalance: 1700,
          //                           color: Color(0xff4527a0),
          //                           creationDate: DateTime(2021, 5, 4),
          //                           description: 'VISA-Card von Tomorrow',
          //                           id: Uuid().v1(),
          //                           initialBankBalance: 1700,
          //                           symbol:
          //                               'assets/icons/account_icons/credit-card.png',
          //                           title: 'Tomorrow'),
          //                       Account(
          //                           accountType: AllData.accountTypes
          //                               .firstWhere((element) =>
          //                                   element.title == 'Tagesgeldkonto'),
          //                           bankBalance: 0,
          //                           color: Color(0xff4527a0),
          //                           creationDate: DateTime(2021, 10, 01),
          //                           description: 'von Wüstenrot',
          //                           id: Uuid().v1(),
          //                           initialBankBalance: 0,
          //                           symbol:
          //                               'assets/icons/account_icons/piggy-bank.png',
          //                           title: 'Wüstenrot'),
          //                       Account(
          //                           accountType: AllData.accountTypes
          //                               .firstWhere((element) =>
          //                                   element.title == 'Bargeldkonto'),
          //                           bankBalance: 150,
          //                           color: Color(0xff4527a0),
          //                           creationDate: DateTime(2021, 5, 4),
          //                           description: 'Geld vom Geldbeutel',
          //                           id: Uuid().v1(),
          //                           initialBankBalance: 200,
          //                           symbol:
          //                               'assets/icons/account_icons/wallet.png',
          //                           title: 'Geldbeutel'),
          //                       Account(
          //                           accountType: AllData.accountTypes
          //                               .firstWhere((element) =>
          //                                   element.title == 'Bargeldkonto'),
          //                           bankBalance: 1800,
          //                           color: Color(0xff4527a0),
          //                           creationDate: DateTime(2021, 5, 4),
          //                           description: 'Bargeld auf Vorrat',
          //                           id: Uuid().v1(),
          //                           initialBankBalance: 1800,
          //                           symbol:
          //                               'assets/icons/account_icons/safe.png',
          //                           title: 'Vorrat'),
          //                       Account(
          //                           accountType: AllData.accountTypes
          //                               .firstWhere((element) =>
          //                                   element.title == 'Girokonto'),
          //                           bankBalance: 4600,
          //                           color: Color(0xff4527a0),
          //                           creationDate: DateTime(2021, 5, 4),
          //                           description: 'Girokonto der Sparkasse',
          //                           id: Uuid().v1(),
          //                           initialBankBalance: 2400,
          //                           symbol:
          //                               'assets/icons/account_icons/euro.png',
          //                           title: 'Sparkasse'),
          //                     ];
          //                     accounts.forEach((element) {
          //                       DBHelper.insert('Account', element.toMap());
          //                       AllData.accounts.add(element);
          //                     });

          //                     //Postings
          //                     List<Posting> postList = [
          //                       // Posting(
          //                       //   id: Uuid().v1(),
          //                       //   title: '',
          //                       //   account: AllData.accounts.firstWhere(
          //                       //       (element) => element.title == ''),
          //                       //   accountName: '',
          //                       //   amount: 0,
          //                       //   category: AllData.categories.firstWhere(
          //                       //       (element) => element.title == ''),
          //                       //   date: DateTime(2022, 1, 1),
          //                       //   description: '',
          //                       //   isStandingOrder: false,
          //                       //   postingType: PostingType.income,
          //                       //   standingOrder: null,
          //                       // ),
          //                     ];
          //                     postList.forEach((element) {
          //                       DBHelper.insert('Posting', element.toMap());
          //                       AllData.postings.add(element);
          //                     });

          //                     //Transfers
          //                     List<Transfer> transList = [
          //                       // Transfer(
          //                       //     id: Uuid().v1(),
          //                       //     accountFrom: AllData.accounts.firstWhere(
          //                       //         (element) => element.title == ''),
          //                       //     accountFromName: '',
          //                       //     accountTo: AllData.accounts.firstWhere(
          //                       //         (element) => element.title == ''),
          //                       //     accountToName: '',
          //                       //     amount: 0,
          //                       //     date: DateTime(2022, 1, 1),
          //                       //     description: ''),
          //                     ];
          //                     transList.forEach((element) {
          //                       DBHelper.insert('Transfer', element.toMap());
          //                       AllData.transfers.add(element);
          //                     });

          //                     //StandingOrder
          //                     List<StandingOrder> soList = [
          //                       StandingOrder(
          //                           id: Uuid().v1(),
          //                           account: AllData.accounts.firstWhere(
          //                               (element) =>
          //                                   element.title == 'Wüstenrot'),
          //                           amount: 1000,
          //                           begin: DateTime(2021, 10, 15),
          //                           end: DateTime(2022, 3, 15),
          //                           category: AllData.categories.firstWhere(
          //                             (element) => element.title == 'Sonstiges',
          //                           ),
          //                           description:
          //                               'Monatliche Einzahlung zum sparen',
          //                           postingType: PostingType.income,
          //                           repetition: Repetition.monthly,
          //                           title: 'Sparvertrag'),
          //                       StandingOrder(
          //                           id: Uuid().v1(),
          //                           account: AllData.accounts.firstWhere(
          //                               (element) =>
          //                                   element.title == 'Sparkasse'),
          //                           amount: 240,
          //                           begin: DateTime(2021, 12, 30),
          //                           category: AllData.categories.firstWhere(
          //                             (element) => element.title == 'Auto',
          //                           ),
          //                           description: 'Auto Leasing',
          //                           postingType: PostingType.expense,
          //                           repetition: Repetition.monthly,
          //                           title: 'Leasing'),
          //                       StandingOrder(
          //                           id: Uuid().v1(),
          //                           account: AllData.accounts.firstWhere(
          //                               (element) =>
          //                                   element.title == 'Tomorrow'),
          //                           amount: 50,
          //                           begin: DateTime(2022, 01, 15),
          //                           category: AllData.categories.firstWhere(
          //                             (element) =>
          //                                 element.title == 'Handyvertrag',
          //                           ),
          //                           description:
          //                               'Test für Handyvertrag --- Dauerauftraaag.',
          //                           postingType: PostingType.expense,
          //                           repetition: Repetition.weekly,
          //                           title: 'Handyvertrag'),
          //                       StandingOrder(
          //                           id: Uuid().v1(),
          //                           account: AllData.accounts.firstWhere(
          //                               (element) =>
          //                                   element.title == 'Sparkasse'),
          //                           amount: 2100,
          //                           begin: DateTime(2022, 01, 15),
          //                           category: AllData.categories.firstWhere(
          //                             (element) => element.title == 'Lohn',
          //                           ),
          //                           description: 'Monatlciher Lohn',
          //                           postingType: PostingType.income,
          //                           repetition: Repetition.weekly,
          //                           title: 'Lohn'),
          //                     ];

          //                     soList.forEach((element) {
          //                       DBHelper.insert(
          //                           'StandingOrder', element.toMap());
          //                       AllData.standingOrders.add(element);
          //                     });
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: const Text("Add")),
          //               TextButton(
          //                 onPressed: () => Navigator.of(context).pop(false),
          //                 child: const Text("Abbrechen"),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //   ),
          // )
        ],
      ),
      drawer: AppDrawer(
        selectedMenuItem: 'settings',
      ),
    );
  }
}