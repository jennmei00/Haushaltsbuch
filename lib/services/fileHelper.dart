import 'dart:io';

import 'package:haushaltsbuch/models/applog.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/AccountVisibility.txt');
  }

  Future<File> get _appLogFile async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/AppLog.log');
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

  Future<bool> fileExists() async {
    final file = await _localFile;
    // file.deleteSync();

    return file.existsSync();
  }

  Future<Map<String, bool>> readMap() async {
    try {
      final file = await _localFile;
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
      print(ex);
      FileHelper()
          .writeAppLog(AppLog(ex.toString(), 'Read Map AccountVisibility'));

      // If encountering an error, return empty map
      return {};
    }
  }

  Future<File> writeMap(Map<String, bool> map) async {
    final file = await _localFile;

    String mapString = '';

    map.forEach((key, value) {
      mapString += '$key:$value\n';
    });

    // Write the file
    return file.writeAsString('$mapString');
  }

  Future<File> writeMapAppend(Map<String, bool> map) async {
    final file = await _localFile;

    String mapString = '';

    map.forEach((key, value) {
      mapString += '$key:$value\n';
    });

    // Write the file
    return file.writeAsString('$mapString', mode: FileMode.append);
  }
}
