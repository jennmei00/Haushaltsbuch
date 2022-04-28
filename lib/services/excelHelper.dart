import 'dart:io';

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

  Future<void> createExcel() async {
    final Workbook workbook = new Workbook();

  }

//   // Create a new Excel document.
// final Workbook workbook = new Workbook();
// //Accessing worksheet via index.
// workbook.worksheets[0];
// // Save the document.
// final List<int> bytes = workbook.saveAsStream();
// File('CreateExcel.xlsx').writeAsBytes(bytes);
// //Dispose the workbook.
// workbook.dispose();

}
