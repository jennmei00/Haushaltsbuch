import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:haushaltsbuch/screens/settings/credits_screen.dart';
import 'package:haushaltsbuch/screens/settings/user_data_screen.dart';
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
    String dbName = "HaushaltsbuchDownload.db";
    String? downloadPath = await FileHelper().getDownloadPath();
    final dbPath = await getDatabasesPath();

    var dbFile = File('$dbPath/Haushaltsbuch.db');
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
      if (file.path.endsWith('HaushaltsbuchDownload.db')) {
        final dbPath = await getDatabasesPath() + '/Haushaltsbuch.db';
        var dbFileBytes = file.readAsBytesSync();
        var bytes = ByteData.view(dbFileBytes.buffer);
        final buffer = bytes.buffer;
        File(dbPath).writeAsBytes(buffer.asUint8List(
            dbFileBytes.offsetInBytes, dbFileBytes.lengthInBytes));

        FileHelper().deleteFile('AccountVisibility');

        Phoenix.rebirth(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('invalid-file'.i18n())));
      }
    } else {
      //canceld pick
      print('canceld pick');
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
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'user-data'.i18n(),
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(UserDataScreen.routeName);
            },
          ),
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
          // GestureDetector(
          //   child: ListTile(
          //     leading: Icon(Icons.table_chart_outlined),
          //     title: Text('Excel Export'),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(ExcelExport.routeName);
          //   },
          // ),
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
                                      content: Text('saved-database'.i18n())));
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
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                foregroundColor: WidgetStateProperty.all(Colors.red),
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
        ],
      ),
      drawer: AppDrawer(selectedMenuItem: 'settings'),
    );
  }
}
