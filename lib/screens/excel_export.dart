import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelExport extends StatelessWidget {
  const ExcelExport({ Key? key }) : super(key: key);
  static final routeName = '/excel_export';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Excel Export'),),
      body: Container(
        child: Center(
          child: ElevatedButton(child: Text('Export'), onPressed: createExcel),
        ),
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
        sheet.getRangeByName('A2').setNumber(2);
    sheet.getRangeByName('A3').setNumber(5);
    sheet.getRangeByName('A4').setFormula('=A2+A3');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush:  true);
    OpenFile.open(fileName);
        print(path);
  }
}