import 'dart:io';

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
    } catch (e) {
      print(e);
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
