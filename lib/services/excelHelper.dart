import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ExcelExport.xlsx');
  }

  Future<void> writeExcel(List<int> bytes) async {
    File file = await _localFile;
    await file.writeAsBytes(bytes, flush: true);

    final path = await _localPath;
    OpenFile.open('$path/ExcelExport.xlsx');
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:F1').setText('Mein Haushaltsbuch');
    sheet.getRangeByName('A5').setText('Gesamteinnahmen');
    sheet.getRangeByName('A6').setText('Gesamtausgaben');
    sheet.getRangeByName('A7').setText('Ausgaben (variabel + Freizeit)');
    sheet.getRangeByName('A8').setText('Großausgaben');
    sheet.getRangeByName('A9').setText('Rest');
    sheet.getRangeByName('A11').setText('Einnahmen');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    writeExcel(bytes);
  }
}
