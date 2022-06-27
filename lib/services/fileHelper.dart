import 'dart:convert';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _accountVisibilityFile async {
    final path = await _localPath;
    return File('$path/AccountVisibility.txt');
  }

  Future<File> get _appLogFile async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/AppLog.log');
  }

  Future<File> get _currencyFile async {
    final path = await _localPath;
    return File('$path/currency.text');
  }

  Future<void> writeAppLog(AppLog appLog) async {
    File file = await _appLogFile;
    String text = appLog.datetime!.toIso8601String() + '|';
    text += appLog.exception! + '|';
    text += appLog.explanation! + '|';
    text += appLog.appVersion! + '\n';
    file.writeAsStringSync('$text', mode: FileMode.append);
  }

  Future<void> clearAppLog() async {
    File file = await _appLogFile;
    file.writeAsStringSync('', mode: FileMode.writeOnly);
  }

  Future<void> writeCurrency(Currency currency) async {
    File file = await _currencyFile;
    file.writeAsStringSync(json.encode(currency.toJson()));
  }

  Future<Currency> readCurrency() async {
    File file = await _currencyFile;
    return Currency.from(json: json.decode(file.readAsStringSync()));
  }

  Future<bool> fileExists(String fileName) async {
    File file;
    switch (fileName) {
      case 'AccountVisibility':
        file = await _accountVisibilityFile;
        break;
      case 'Currency':
        file = await _currencyFile;
        break;
      default:
        return false;
    }

    // file.deleteSync();
    return file.existsSync();
  }

  Future<void> deleteFile(String fileName) async {
    File file;
    switch(fileName) {
      case 'AccountVisibility':
        file = await _accountVisibilityFile;
        break;
      default: 
        return;
    }
      file.deleteSync();
  }

  Future<Map<String, bool>> readMap() async {
    try {
      final file = await _accountVisibilityFile;
      Map<String, bool> map = {};
      // Read the file
      final List<String> contents = await file.readAsLines();
      contents.forEach((element) {
        String s = element.split(':').first;
        bool b = element.split(':').last == 'false' ? false : true;
        map[s] = b;
      });

      return map;
    } catch (ex) {
      print('FileHelper Screen $ex');
      FileHelper()
          .writeAppLog(AppLog(ex.toString(), 'Read Map AccountVisibility'));

      // If encountering an error, return empty map
      return {};
    }
  }

  Future<File> writeMap(Map<String, bool> map) async {
    final file = await _accountVisibilityFile;

    String mapString = '';

    map.forEach((key, value) {
      mapString += '$key:$value\n';
    });

    // Write the file
    return file.writeAsString('$mapString');
  }

  Future<File> writeMapAppend(Map<String, bool> map) async {
    final file = await _accountVisibilityFile;

    String mapString = '';

    map.forEach((key, value) {
      mapString += '$key:$value\n';
    });

    // Write the file
    return file.writeAsString('$mapString', mode: FileMode.append);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (ex) {
      print("Cannot get download folder path");
      
      FileHelper()
          .writeAppLog(AppLog(ex.toString(), 'getDownloadPath'));
    }
    return directory?.path;
  }
}
