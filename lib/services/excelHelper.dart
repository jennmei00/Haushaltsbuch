import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
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

  // Future<void> _writeExcel(List<int> bytes) async {
  //   File file = await _localFile;
  //   await file.writeAsBytes(bytes, flush: true);
  // }

  Future<void> openExcel(List<int> bytes) async {
    File file = await _localFile;
    await file.writeAsBytes(bytes, flush: true);

    final path = await _localPath;
    OpenFile.open('$path/ExcelExport.xlsx');
  }

  Future<bool> downloadExcel(dynamic bytes) async {
    // _writeExcel(bytes);

    String excelName = "ExcelExport.xlsx";
    String? downloadPath = await FileHelper().getDownloadPath();

    // var excelFile = await _localFile;
    var filePath = downloadPath! + '/$excelName';
    var excelFileBytes = bytes;
    var excelBytes = ByteData.view(excelFileBytes.buffer);
    final buffer = excelBytes.buffer;

    File f = await File(filePath).writeAsBytes(
        buffer.asUint8List(excelBytes.offsetInBytes, excelBytes.lengthInBytes));

    return await f.length() > 0 ? true : false;
  }

  Future<void> createExcel(
      {
      // required Month startMonth,
      // required int startYear,
      // required Month endMonth,
      // required int endYear,
      required bool download,
      required DateTimeRange dateRange,
      required List<Account> selectedAccounts,
      required List<Category> variableExpenses,
      required List<Category> freetimeExpenses,
      required bool bigExpenses,
      required double bigExpensesAmount,
      required BuildContext context}) async {
    //Add Lists for data
    List<Posting> incomeStandingOrderPostings = [];
    List<Posting> expenseStandingOrderPostings = [];
    List<Posting> variableExpensesPostings = [];
    List<Posting> freetimeExpensesPosting = [];
    List<Posting> bigExpensesPosting = [];
    List<StandingOrder> incomeStandingOrders = [];
    List<StandingOrder> expenseStandingOrders = [];

    //Fill Lists
    _fillLists(dateRange, incomeStandingOrderPostings, expenseStandingOrderPostings, bigExpenses, variableExpenses, variableExpensesPostings, freetimeExpenses, freetimeExpensesPosting, bigExpensesAmount, bigExpensesPosting, incomeStandingOrders, expenseStandingOrders);

    //Sort Lists
    incomeStandingOrderPostings
        .sort((obj, obj2) => obj2.date!.compareTo(obj.date!));
    expenseStandingOrderPostings
        .sort((obj, obj2) => obj2.date!.compareTo(obj.date!));
    variableExpensesPostings
        .sort((obj, obj2) => obj.date!.compareTo(obj2.date!));
    freetimeExpensesPosting
        .sort((obj, obj2) => obj.date!.compareTo(obj2.date!));
    bigExpensesPosting.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    // sheet.name = 'Haushaltsbuch';

    //Style
    final Style styleExpense = workbook.styles.add('styleExpense');
    styleExpense.fontColor = '#990000';
    styleExpense.numberFormat = '#,##0.00 [\$€-407]';
    final Style styleIncome = workbook.styles.add('styleIncome');
    styleIncome.fontColor = '#006600';
    styleIncome.numberFormat = '#,##0.00 [\$€-407]';
    final Style styleBigExpense = workbook.styles.add('styleBigExpense');
    styleBigExpense.fontColor = '#990066';
    styleBigExpense.numberFormat = '#,##0.00 [\$€-407]';
    final Style styleRest = workbook.styles.add('styleRest');
    styleRest.fontColor = '#990066';
    styleRest.numberFormat =
        '[BLUE]#,##0.00 [\$€-407]; [RED]-#,##0.00 [\$€-407]';

    //Überschrift
    int titleRange = _header(dateRange, sheet);

    //Datumsüberschrift
    Map<int, List<Month>> dates = _dateHeader(dateRange, sheet);

    //Gesamtübersicht
    Range r;
    r = sheet.getRangeByName('A5');
    r.setText('Gesamteinnahmen');
    r.cellStyle.bold = true;
    r = sheet.getRangeByName('A6');
    r.setText('Gesamtausgaben');
    r.cellStyle.bold = true;
    if (bigExpenses) {
      r = sheet.getRangeByName('A7');
      r.setText('Großausgaben');
      r.cellStyle.bold = true;
      r = sheet.getRangeByName('A8');
      r.setText('Rest  (mit Großausgaben)');
      r.cellStyle.bold = true;
      r = sheet.getRangeByName('A9');
      r.setText('Rest (ohne Großausgaben)');
      r.cellStyle.bold = true;
    } else {
      r = sheet.getRangeByName('A7');
      r.setText('Rest');
      r.cellStyle.bold = true;
    }

    //Jahresübersicht
    _yearOverview(sheet, titleRange, bigExpenses, styleIncome, styleExpense,
        styleBigExpense, styleRest);

    //get empty Row position
    Range beforeIncome;
    if (bigExpenses) {
      beforeIncome = sheet.getRangeByIndex(10, 1, 10, titleRange);
    } else {
      beforeIncome = sheet.getRangeByIndex(8, 1, 8, titleRange);
    }
    final Range beforeExpenseStandingorder = sheet.getRangeByIndex(
        beforeIncome.lastRow + incomeStandingOrders.length + 4,
        1,
        beforeIncome.lastRow + incomeStandingOrders.length + 4,
        titleRange);
    final Range beforeVariableExpenses = sheet.getRangeByIndex(
        beforeExpenseStandingorder.lastRow + expenseStandingOrders.length + 4,
        1,
        beforeExpenseStandingorder.lastRow + expenseStandingOrders.length + 4,
        titleRange);
    final Range beforeFreetimeExpenses = sheet.getRangeByIndex(
        beforeVariableExpenses.lastRow + variableExpensesPostings.length + 4,
        1,
        beforeVariableExpenses.lastRow + variableExpensesPostings.length + 4,
        titleRange);
    Range? beforeBigExpenses;
    if (bigExpenses) {
      beforeBigExpenses = sheet.getRangeByIndex(
          beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 4,
          1,
          beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 4,
          titleRange);
      beforeBigExpenses.merge();
      beforeBigExpenses.cellStyle.backColor = '#CCCCCC';
      beforeBigExpenses.cellStyle.borders.top.lineStyle = LineStyle.double;
      beforeBigExpenses.cellStyle.borders.bottom.lineStyle = LineStyle.double;
    }
    beforeIncome.merge();
    beforeExpenseStandingorder.merge();
    beforeVariableExpenses.merge();
    beforeFreetimeExpenses.merge();

    //Style
    Range styleRange1;
    Range styleRange2;
    Range styleRange3;
    if (!bigExpenses) {
      styleRange1 = sheet.getRangeByIndex(
          5,
          1,
          beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3,
          1);
      styleRange2 = sheet.getRangeByIndex(
          5,
          2,
          beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3,
          2);
      styleRange3 = sheet.getRangeByIndex(
          5,
          3,
          beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3,
          3);
    } else {
      styleRange1 = sheet.getRangeByIndex(
          5, 1, beforeBigExpenses!.lastRow + bigExpensesPosting.length + 3, 1);
      styleRange2 = sheet.getRangeByIndex(
          5, 2, beforeBigExpenses.lastRow + bigExpensesPosting.length + 3, 2);
      styleRange3 = sheet.getRangeByIndex(
          5, 3, beforeBigExpenses.lastRow + bigExpensesPosting.length + 3, 3);
    }
    styleRange1.cellStyle.backColor = '#CCCCCC';
    styleRange2.cellStyle.backColor = '#DDDDDD';
    styleRange3.cellStyle.backColor = '#EEEEEE';
    beforeIncome.cellStyle.backColor = '#CCCCCC';
    beforeExpenseStandingorder.cellStyle.backColor = '#CCCCCC';
    beforeVariableExpenses.cellStyle.backColor = '#CCCCCC';
    beforeFreetimeExpenses.cellStyle.backColor = '#CCCCCC';
    r = sheet.getRangeByIndex(4, 1, 4, titleRange);
    r.cellStyle.backColor = '#CCCCCC';
    r.cellStyle.borders.bottom.lineStyle = LineStyle.double;
    beforeIncome.cellStyle.borders.top.lineStyle = LineStyle.double;
    beforeIncome.cellStyle.borders.bottom.lineStyle = LineStyle.double;
    beforeExpenseStandingorder.cellStyle.borders.top.lineStyle =
        LineStyle.double;
    beforeExpenseStandingorder.cellStyle.borders.bottom.lineStyle =
        LineStyle.double;
    beforeVariableExpenses.cellStyle.borders.top.lineStyle = LineStyle.double;
    beforeVariableExpenses.cellStyle.borders.bottom.lineStyle =
        LineStyle.double;
    beforeFreetimeExpenses.cellStyle.borders.top.lineStyle = LineStyle.double;
    beforeFreetimeExpenses.cellStyle.borders.bottom.lineStyle =
        LineStyle.double;

    //Write Income Standingorders
    _writeIncomeStandingorders(sheet, beforeIncome, incomeStandingOrders,
        context, dates, incomeStandingOrderPostings, styleIncome);

    //Write Expense Standingorders
    _writeExpenseStandingorders(
        sheet,
        beforeExpenseStandingorder,
        expenseStandingOrders,
        context,
        dates,
        expenseStandingOrderPostings,
        styleExpense);

    //Write variable Expenses
    _writeVariableExpenses(sheet, beforeVariableExpenses, variableExpenses,
        variableExpensesPostings, dates, styleExpense);

    //Write freetime Expenses
    _writeFreetimeExpenses(sheet, beforeFreetimeExpenses, freetimeExpenses,
        freetimeExpensesPosting, dates, styleExpense);

    //Write big Expenses
    _writeBigExpenses(bigExpenses, bigExpensesPosting, dates, sheet,
        beforeBigExpenses, styleExpense);

    //Write Totalamounts
    _writeTotalAmounts(
        dates,
        sheet,
        beforeIncome,
        incomeStandingOrders,
        beforeExpenseStandingorder,
        expenseStandingOrders,
        beforeVariableExpenses,
        variableExpensesPostings,
        beforeFreetimeExpenses,
        freetimeExpensesPosting,
        bigExpenses,
        beforeBigExpenses,
        bigExpensesPosting,
        styleIncome,
        styleExpense,
        styleBigExpense,
        styleRest);

    Range styleRange;
    if (bigExpenses)
      styleRange = sheet.getRangeByIndex(5, 3, 9, titleRange);
    else
      styleRange = sheet.getRangeByIndex(5, 3, 7, titleRange);

    styleRange.cellStyle.backColor = '#EEEEEE';
    if (!bigExpenses) {
      r = sheet.getRangeByIndex(
          beforeFreetimeExpenses.lastRow + 4 + freetimeExpensesPosting.length,
          1,
          beforeFreetimeExpenses.lastRow + 4 + freetimeExpensesPosting.length,
          titleRange);
      r.cellStyle.backColor = '#CCCCCC';
    } else {
      r = sheet.getRangeByIndex(
          beforeBigExpenses!.lastRow + 4 + bigExpensesPosting.length,
          1,
          beforeBigExpenses.lastRow + 4 + bigExpensesPosting.length,
          titleRange);
      r.cellStyle.backColor = '#CCCCCC';
    }
    r.cellStyle.borders.top.lineStyle = LineStyle.double;
    r.cellStyle.borders.bottom.lineStyle = LineStyle.double;

    //Save and open sheet
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (download) {
      downloadExcel(bytes);
    } else {
      openExcel(bytes);
    }
  }

  void _fillLists(DateTimeRange dateRange, List<Posting> incomeStandingOrderPostings, List<Posting> expenseStandingOrderPostings, bool bigExpenses, List<Category> variableExpenses, List<Posting> variableExpensesPostings, List<Category> freetimeExpenses, List<Posting> freetimeExpensesPosting, double bigExpensesAmount, List<Posting> bigExpensesPosting, List<StandingOrder> incomeStandingOrders, List<StandingOrder> expenseStandingOrders) {
     AllData.postings.forEach((element) {
      if ((element.date!.isAfter(dateRange.start) &&
              element.date!.isBefore(dateRange.end)) ||
          element.date!.isAtSameMomentAs(dateRange.start) ||
          element.date!.isAtSameMomentAs(dateRange.end)) {
        if (element.postingType == PostingType.income) {
          if (element.isStandingOrder == true) {
            incomeStandingOrderPostings.add(element);
          }
        } else {
          if (element.isStandingOrder == true) {
            expenseStandingOrderPostings.add(element);
          } else if (!bigExpenses) {
            if (variableExpenses.contains(element.category)) {
              variableExpensesPostings.add(element);
            } else if (freetimeExpenses.contains(element.category)) {
              freetimeExpensesPosting.add(element);
            }
          } else {
            if (element.amount! >= bigExpensesAmount) {
              bigExpensesPosting.add(element);
            } else {
              if (variableExpenses.contains(element.category)) {
                variableExpensesPostings.add(element);
              } else if (freetimeExpenses.contains(element.category)) {
                freetimeExpensesPosting.add(element);
              }
            }
          }
        }
      }
    });
    
    AllData.standingOrders.forEach((element) {
      if (element.begin!.isBefore(dateRange.end)) {
        if (element.postingType == PostingType.income) {
          if (element.end != null) {
            if (element.end!.isBefore(dateRange.end)) {
              incomeStandingOrders.add(element);
            }
          } else {
            incomeStandingOrders.add(element);
          }
        } else if (element.postingType == PostingType.expense) {
          if (element.end != null) {
            if (element.end!.isBefore(dateRange.end)) {
              expenseStandingOrders.add(element);
            }
          } else {
            expenseStandingOrders.add(element);
          }
        }
      }
    });
  }

  int _header(DateTimeRange dateRange, Worksheet sheet) {
    int titleRange =
        (Jiffy(dateRange.end).diff(dateRange.start, Units.MONTH).toInt() + 1) *
                2 +
            3;
    final Range title = sheet.getRangeByIndex(1, 1, 1, titleRange);
    title.merge();
    title.text = 'Mein Haushaltsbuch';
    //  - Zeitraum ${'${Month.values[dateRange.start.month - 1].name}'.i18n()} ${dateRange.start.year} - ${'${Month.values[dateRange.end.month - 1].name}'.i18n()} ${dateRange.end.year}';
    title.rowHeight = 22.5;
    title.cellStyle.vAlign = VAlignType.center;
    title.cellStyle.hAlign = HAlignType.center;
    title.cellStyle.bold = true;
    title.cellStyle.underline = true;
    title.cellStyle.fontSize = 14;
    title.cellStyle.backColor = '#9BC2E6';
    return titleRange;
  }

  Map<int, List<Month>> _dateHeader(DateTimeRange dateRange, Worksheet sheet) {
    Map<int, List<Month>> dates = {};
    int year = 0;

    for (DateTime date = dateRange.start;
        date.isBefore(dateRange.end) || date.isAtSameMomentAs(dateRange.end);
        date = Jiffy(date).add(months: 1).dateTime) {
      if (year == date.year) {
        dates[year]?.add(Month.values[date.month - 1]);
      } else {
        year = date.year;
        dates.addAll({
          year: [Month.values[date.month - 1]]
        });
      }
    }

    Range? dateRange1;
    Range dateRange2;
    dates.forEach((key, value) {
      if (dates.keys.first == key) {
        dateRange2 = sheet.getRangeByIndex(3, 4, 3, value.length * 2 + 3);
      } else {
        dateRange2 = sheet.getRangeByIndex(3, dateRange1!.lastColumn + 1, 3,
            dateRange1!.lastColumn + (value.length * 2));
      }

      dateRange2.merge();
      dateRange2.setNumber(key.toDouble());
      dateRange2.cellStyle.vAlign = VAlignType.center;
      dateRange2.cellStyle.hAlign = HAlignType.center;
      dateRange2.cellStyle.bold = true;
      dateRange2.cellStyle.fontColor = '#000099';
      dateRange2.cellStyle.borders.all.lineStyle = LineStyle.thin;
      dateRange1 = dateRange2;
    });

    Range? monthRange1;
    Range monthRange2;
    dates.forEach((key, value) {
      value.forEach((element) {
        if (dates.keys.first == key && value.first == element) {
          monthRange2 = sheet.getRangeByIndex(4, 4, 4, 5);
        } else {
          monthRange2 = sheet.getRangeByIndex(
              4, monthRange1!.lastColumn + 1, 4, monthRange1!.lastColumn + 2);
        }

        monthRange2.merge();
        monthRange2.setText('${element.name}'.i18n());
        monthRange2.cellStyle.vAlign = VAlignType.center;
        monthRange2.cellStyle.hAlign = HAlignType.center;
        monthRange2.cellStyle.bold = true;
        monthRange1 = monthRange2;
      });
    });
    return dates;
  }

  void _yearOverview(
      Worksheet sheet,
      int titleRange,
      bool bigExpenses,
      Style styleIncome,
      Style styleExpense,
      Style styleBigExpense,
      Style styleRest) {
    final Range yearOverview =
        sheet.getRangeByIndex(4, titleRange + 2, 4, titleRange + 3);
    yearOverview.merge();
    yearOverview.text = 'Jahresübersicht';
    yearOverview.cellStyle.vAlign = VAlignType.center;
    yearOverview.cellStyle.hAlign = HAlignType.center;
    yearOverview.cellStyle.bold = true;
    yearOverview.cellStyle.backColor = '#B2B2B2';
    yearOverview.cellStyle.borders.left.lineStyle = LineStyle.thin;
    yearOverview.cellStyle.borders.right.lineStyle = LineStyle.thin;
    yearOverview.cellStyle.borders.top.lineStyle = LineStyle.thin;

    Range r = sheet.getRangeByIndex(5, titleRange + 2);
    r.setText('Gesamteinnahmen');
    r.cellStyle.bold = true;
    r.cellStyle.borders.left.lineStyle = LineStyle.thin;

    final Range gesamteinnahmen = sheet.getRangeByIndex(5, titleRange);
    final Range gesamtausgaben = sheet.getRangeByIndex(6, titleRange);
    final Range gesamteinnahmenNumber =
        sheet.getRangeByIndex(5, titleRange + 3);
    gesamteinnahmenNumber
        .setFormula('=SUM(E5:${gesamteinnahmen.addressLocal})');
    gesamteinnahmenNumber.cellStyle = styleIncome;
    r = sheet.getRangeByIndex(6, titleRange + 2);
    r.setText('Gesamtausgaben');
    r.cellStyle.bold = true;
    if (bigExpenses) {
      r.cellStyle.borders.left.lineStyle = LineStyle.thin;
    } else {
      r.cellStyle.borders.left.lineStyle = LineStyle.thin;
      r.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    }

    final Range gesamtausgabenNumber = sheet.getRangeByIndex(6, titleRange + 3);
    gesamtausgabenNumber.setFormula('=SUM(E6:${gesamtausgaben.addressLocal})');
    gesamtausgabenNumber.cellStyle = styleExpense;
    gesamteinnahmenNumber.cellStyle.borders.right.lineStyle = LineStyle.thin;

    if (bigExpenses) {
      gesamtausgaben.cellStyle.borders.left.lineStyle = LineStyle.thin;
      gesamtausgabenNumber.cellStyle.borders.right.lineStyle = LineStyle.thin;
      final Range gesamtBigE = sheet.getRangeByIndex(7, titleRange);
      Range rBigE = sheet.getRangeByIndex(7, titleRange + 2);
      rBigE.setText('Großausgaben');
      rBigE.cellStyle.bold = true;
      final Range gesamtBigENumber = sheet.getRangeByIndex(7, titleRange + 3);
      gesamtBigENumber.setFormula('=SUM(E7:${gesamtBigE.addressLocal})');
      gesamtBigENumber.cellStyle = styleBigExpense;
      rBigE.cellStyle.borders.left.lineStyle = LineStyle.thin;
      rBigE.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
      gesamtBigENumber.cellStyle.borders.right.lineStyle = LineStyle.thin;
      gesamtBigENumber.cellStyle.borders.bottom.lineStyle = LineStyle.thin;

      r = sheet.getRangeByIndex(9, titleRange + 2);
      r.setText('Übrig im gewählten Zeitraum');
      r.cellStyle.italic = true;
      r.cellStyle.borders.left.lineStyle = LineStyle.thick;
      r.cellStyle.borders.bottom.lineStyle = LineStyle.thick;
      r.cellStyle.borders.top.lineStyle = LineStyle.thick;
      r = sheet.getRangeByIndex(9, titleRange + 3);
      r.setFormula(
          '=${gesamteinnahmenNumber.addressLocal}-${gesamtausgabenNumber.addressLocal}-${gesamtBigENumber.addressLocal}');
      r.cellStyle = styleRest;
      r.cellStyle.borders.right.lineStyle = LineStyle.thick;
      r.cellStyle.borders.bottom.lineStyle = LineStyle.thick;
      r.cellStyle.borders.top.lineStyle = LineStyle.thick;
    } else {
      gesamtausgabenNumber.cellStyle.borders.right.lineStyle = LineStyle.thin;
      gesamtausgabenNumber.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
      r = sheet.getRangeByIndex(8, titleRange + 2);
      r.setText('Übrig im gewählten Zeitraum');
      r.cellStyle.italic = true;
      r.cellStyle.borders.left.lineStyle = LineStyle.thick;
      r.cellStyle.borders.bottom.lineStyle = LineStyle.thick;
      r.cellStyle.borders.top.lineStyle = LineStyle.thick;

      r = sheet.getRangeByIndex(8, titleRange + 3);
      r.setFormula(
          '=${gesamteinnahmenNumber.addressLocal}-${gesamtausgabenNumber.addressLocal}');
      r.cellStyle = styleRest;
      r.cellStyle.borders.right.lineStyle = LineStyle.thick;
      r.cellStyle.borders.bottom.lineStyle = LineStyle.thick;
      r.cellStyle.borders.top.lineStyle = LineStyle.thick;
    }
  }

  void _writeTotalAmounts(
      Map<int, List<Month>> dates,
      Worksheet sheet,
      Range beforeIncome,
      List<StandingOrder> incomeStandingOrders,
      Range beforeExpenseStandingorder,
      List<StandingOrder> expenseStandingOrders,
      Range beforeVariableExpenses,
      List<Posting> variableExpensesPostings,
      Range beforeFreetimeExpenses,
      List<Posting> freetimeExpensesPosting,
      bool bigExpenses,
      Range? beforeBigExpenses,
      List<Posting> bigExpensesPosting,
      Style styleIncome,
      Style styleExpense,
      Style styleBigExpense,
      Style styleRest) {
    int x = 1;
    dates.forEach((key, value) {
      value.forEach((element) {
        //Income StandingOrders
        Range r1 = sheet.getRangeByIndex(beforeIncome.lastRow + 2, 3 + x * 2);
        Range r2 = sheet.getRangeByIndex(
            beforeIncome.lastRow + incomeStandingOrders.length + 1, 3 + x * 2);
        Range r = sheet.getRangeByIndex(
            beforeIncome.lastRow + incomeStandingOrders.length + 3, 3 + x * 2);
        r.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
        r.cellStyle = styleIncome;
        Range range = sheet.getRangeByIndex(5, 3 + x * 2);
        range.setFormula('=${r.addressLocal}');
        range.cellStyle = styleIncome;

        //Expense StandingOrders
        r1 = sheet.getRangeByIndex(
            beforeExpenseStandingorder.lastRow + 2, 3 + x * 2);
        r2 = sheet.getRangeByIndex(
            beforeExpenseStandingorder.lastRow +
                expenseStandingOrders.length +
                1,
            3 + x * 2);
        Range varE = sheet.getRangeByIndex(
            beforeVariableExpenses.lastRow +
                variableExpensesPostings.length +
                3,
            3 + x * 2);

        Range varF = sheet.getRangeByIndex(
            beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3,
            3 + x * 2);
        r = sheet.getRangeByIndex(
            beforeExpenseStandingorder.lastRow +
                expenseStandingOrders.length +
                3,
            3 + x * 2);
        r.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
        r.cellStyle = styleExpense;
        range = sheet.getRangeByIndex(6, 3 + x * 2);
        range.setFormula(
            '=${r.addressLocal}+${varE.addressLocal}+${varF.addressLocal}');
        range.cellStyle = styleExpense;

        //Variable Expenses
        r1 = sheet.getRangeByIndex(
            beforeVariableExpenses.lastRow + 2, 3 + x * 2);
        r2 = sheet.getRangeByIndex(
            beforeVariableExpenses.lastRow +
                variableExpensesPostings.length +
                1,
            3 + x * 2);
        Range r3 = sheet.getRangeByIndex(
            beforeVariableExpenses.lastRow + 3, 3 + x * 2);
        Range r4 = sheet.getRangeByIndex(
            beforeFreetimeExpenses.lastRow + 3, 3 + x * 2);
        varE = sheet.getRangeByIndex(
            beforeVariableExpenses.lastRow +
                variableExpensesPostings.length +
                3,
            3 + x * 2);
        varE.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
        varE.cellStyle = styleExpense;

        //Freetime Expenses
        r1 = sheet.getRangeByIndex(
            beforeFreetimeExpenses.lastRow + 2, 3 + x * 2);
        r2 = sheet.getRangeByIndex(
            beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 1,
            3 + x * 2);
        varF = sheet.getRangeByIndex(
            beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3,
            3 + x * 2);
        varF.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
        varF.cellStyle = styleExpense;

        r = sheet.getRangeByIndex(7, 3 + x * 2);
        r.setFormula('=SUM(${varE.addressLocal}:${varF.addressLocal})');
        r.cellStyle = styleExpense;

        //Big Expenses
        if (bigExpenses) {
          r1 = sheet.getRangeByIndex(beforeBigExpenses!.lastRow + 2, 3 + x * 2);
          r2 = sheet.getRangeByIndex(
              beforeBigExpenses.lastRow + bigExpensesPosting.length + 1,
              3 + x * 2);
          r = sheet.getRangeByIndex(
              beforeBigExpenses.lastRow + bigExpensesPosting.length + 3,
              3 + x * 2);
          r.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
          r.cellStyle = styleExpense;

          range = sheet.getRangeByIndex(7, 3 + x * 2);
          range.setFormula('=${r.addressLocal}');
          range.cellStyle = styleBigExpense;
        }
        //Rest
        r1 = sheet.getRangeByIndex(5, 3 + x * 2);
        r2 = sheet.getRangeByIndex(6, 3 + x * 2);
        r3 = sheet.getRangeByIndex(7, 3 + x * 2);
        r4 = sheet.getRangeByIndex(8, 3 + x * 2);

        r = sheet.getRangeByIndex(9, 3 + x * 2);
        if (bigExpenses) {
          r4.setFormula(
              '=${r1.addressLocal}-${r2.addressLocal}-${r3.addressLocal}');
          r4.cellStyle = styleRest;
          r.setFormula('=${r1.addressLocal}-${r2.addressLocal}');
          r.cellStyle = styleRest;
        } else {
          r3.setFormula('=${r1.addressLocal}-${r2.addressLocal}');
          r3.cellStyle = styleRest;
        }
        x++;
      });
    });
  }

  void _writeBigExpenses(
      bool bigExpenses,
      List<Posting> bigExpensesPosting,
      Map<int, List<Month>> dates,
      Worksheet sheet,
      Range? beforeBigExpenses,
      Style styleExpense) {
    if (bigExpenses) {
      int i = 1;
      bigExpensesPosting.forEach((p) {
        int x = 1;
        dates.forEach((key, value) {
          value.forEach((val) {
            if (p.date!.month == val.index + 1 && p.date!.year == key) {
              Range range = sheet.getRangeByIndex(
                  beforeBigExpenses!.lastRow + 1 + i, 3 + x * 2);
              range.setNumber(p.amount);
              range.cellStyle = styleExpense;
            }
            x++;
          });
        });
        sheet
            .getRangeByIndex(beforeBigExpenses!.lastRow + 1 + i, 4)
            .setText('${p.title}');
        i++;
      });

      Range r = sheet.getRangeByIndex(beforeBigExpenses!.lastRow + 1, 1);
      r.setText('Großausgaben');
      r.cellStyle.bold = true;
      
      r = sheet.getRangeByIndex(
          beforeBigExpenses.lastRow + bigExpensesPosting.length + 3, 2);
      r.setText('Gesamt');
      r.cellStyle.bold = true;
      r.cellStyle.underline = true;
    }
  }

  void _writeFreetimeExpenses(
      Worksheet sheet,
      Range beforeFreetimeExpenses,
      List<Category> freetimeExpenses,
      List<Posting> freetimeExpensesPosting,
      Map<int, List<Month>> dates,
      Style styleExpense) {
    Range r = sheet.getRangeByIndex(beforeFreetimeExpenses.lastRow + 1, 1);
    r.setText('Freizeitausgaben');
    r.cellStyle.bold = true;
    String freetimeCategories = '';
    freetimeExpenses.forEach((element) {
      freetimeCategories += '${element.title}';
      if (freetimeExpenses.last != element) {
        freetimeCategories += ', ';
      }
    });

    int iFE = 1;
    freetimeExpensesPosting.forEach((p) {
      int x = 1;
      dates.forEach((key, value) {
        value.forEach((val) {
          if (p.date!.month == val.index + 1 && p.date!.year == key) {
            Range range = sheet.getRangeByIndex(
                beforeFreetimeExpenses.lastRow + 1 + iFE, 3 + x * 2);
            range.setNumber(p.amount);
            range.cellStyle = styleExpense;
          }
          x++;
        });
      });
      sheet
          .getRangeByIndex(beforeFreetimeExpenses.lastRow + 1 + iFE, 4)
          .setText('${p.title}');
      iFE++;
    });
    r = sheet.getRangeByIndex(beforeFreetimeExpenses.lastRow + 2, 1);
    r.setText('$freetimeCategories');
    r.cellStyle.italic = true;

    r = sheet.getRangeByIndex(
        beforeFreetimeExpenses.lastRow + freetimeExpensesPosting.length + 3, 2);
    r.setText('Gesamt');
    r.cellStyle.bold = true;
    r.cellStyle.underline = true;
  }

  void _writeVariableExpenses(
      Worksheet sheet,
      Range beforeVariableExpenses,
      List<Category> variableExpenses,
      List<Posting> variableExpensesPostings,
      Map<int, List<Month>> dates,
      Style styleExpense) {
    Range r = sheet.getRangeByIndex(beforeVariableExpenses.lastRow + 1, 1);
    r.setText('vaiable Ausgaben');
    r.cellStyle.bold = true;
    String variableCategories = '';
    variableExpenses.forEach((element) {
      variableCategories += '${element.title}';
      if (variableExpenses.last != element) {
        variableCategories += ', ';
      }
    });

    int iVE = 1;
    variableExpensesPostings.forEach((p) {
      int x = 1;
      dates.forEach((key, value) {
        value.forEach((val) {
          if (p.date!.month == val.index + 1 && p.date!.year == key) {
            Range range = sheet.getRangeByIndex(
                beforeVariableExpenses.lastRow + 1 + iVE, 3 + x * 2);
            range.setNumber(p.amount);
            range.cellStyle = styleExpense;
          }
          x++;
        });
      });
      sheet
          .getRangeByIndex(beforeVariableExpenses.lastRow + 1 + iVE, 4)
          .setText('${p.title}');
      iVE++;
    });

    r = sheet.getRangeByIndex(beforeVariableExpenses.lastRow + 2, 1);
    r.setText('$variableCategories');
    r.cellStyle.italic = true;
    r = sheet.getRangeByIndex(
        beforeVariableExpenses.lastRow + variableExpensesPostings.length + 3,
        2);
    r.setText('Gesamt');
    r.cellStyle.bold = true;
    r.cellStyle.underline = true;
  }

  void _writeExpenseStandingorders(
      Worksheet sheet,
      Range beforeExpenseStandingorder,
      List<StandingOrder> expenseStandingOrders,
      BuildContext context,
      Map<int, List<Month>> dates,
      List<Posting> expenseStandingOrderPostings,
      Style styleExpense) {
    Range r = sheet.getRangeByIndex(beforeExpenseStandingorder.lastRow + 1, 1);
    r.setText('Fixkosten');
    r.cellStyle.bold = true;
    r = sheet.getRangeByIndex(beforeExpenseStandingorder.lastRow + 1, 3);
    r.setText('Startdatum/Wdh');
    r.cellStyle.bold = true;
    r = sheet.getRangeByIndex(
        beforeExpenseStandingorder.lastRow + expenseStandingOrders.length + 3,
        2);
    r.setText('Gesamt');
    r.cellStyle.bold = true;
    r.cellStyle.underline = true;
    int iSoE = 1;
    expenseStandingOrders.forEach((element) {
      sheet
          .getRangeByIndex(beforeExpenseStandingorder.lastRow + 1 + iSoE, 2)
          .setText('${element.title}');
      sheet
          .getRangeByIndex(beforeExpenseStandingorder.lastRow + 1 + iSoE, 3)
          .setText(
              '${formatDate(element.begin!, context)}/${formatRepetition(element.repetition!)}');

      int x = 1;
      dates.forEach((key, value) {
        value.forEach((val) {
          Posting? posting = expenseStandingOrderPostings.firstWhere(
              (p) =>
                  p.date!.month == val.index + 1 &&
                  p.date!.year == key &&
                  p.standingOrder!.id == element.id,
              orElse: () => Posting(id: 'NULL'));
          if (posting.id != 'NULL') {
            Range range = sheet.getRangeByIndex(
                beforeExpenseStandingorder.lastRow + 1 + iSoE, 3 + x * 2);
            range.setNumber(posting.amount);
            range.cellStyle = styleExpense;
          }
          x++;
        });
      });

      iSoE++;
    });
  }

  void _writeIncomeStandingorders(
      Worksheet sheet,
      Range beforeIncome,
      List<StandingOrder> incomeStandingOrders,
      BuildContext context,
      Map<int, List<Month>> dates,
      List<Posting> incomeStandingOrderPostings,
      Style styleIncome) {
    Range r = sheet.getRangeByIndex(beforeIncome.lastRow + 1, 1);
    r.setText('Einnahmen');
    r.cellStyle.bold = true;
    r = sheet.getRangeByIndex(beforeIncome.lastRow + 1, 3);
    r.setText('Startdatum/Wdh');
    r.cellStyle.bold = true;
    r = sheet.getRangeByIndex(
        beforeIncome.lastRow + incomeStandingOrders.length + 3, 2);
    r.setText('Gesamt');
    r.cellStyle.bold = true;
    r.cellStyle.underline = true;
    int iSoI = 1;
    incomeStandingOrders
        .where((element) => element.postingType == PostingType.income)
        .forEach((element) {
      sheet
          .getRangeByIndex(beforeIncome.lastRow + 1 + iSoI, 2)
          .setText('${element.title}');
      sheet.getRangeByIndex(beforeIncome.lastRow + 1 + iSoI, 3).setText(
          '${formatDate(element.begin!, context)}/${formatRepetition(element.repetition!)}');

      int x = 1;
      dates.forEach((key, value) {
        value.forEach((val) {
          Posting? posting = incomeStandingOrderPostings.firstWhere(
              (p) =>
                  p.date!.month == val.index + 1 &&
                  p.date!.year == key &&
                  p.standingOrder!.id == element.id,
              orElse: () => Posting(id: 'NULL'));
          if (posting.id != 'NULL') {
            Range range = sheet.getRangeByIndex(
                beforeIncome.lastRow + 1 + iSoI, 3 + x * 2);
            range.setNumber(posting.amount);
            range.cellStyle = styleIncome;
          }
          final Range r1 =
              sheet.getRangeByIndex(beforeIncome.lastRow + 2, 3 + x * 2);
          final Range r2 = sheet.getRangeByIndex(
              beforeIncome.lastRow + incomeStandingOrders.length + 1,
              3 + x * 2);
          Range range = sheet.getRangeByIndex(
              beforeIncome.lastRow + incomeStandingOrders.length + 3,
              3 + x * 2);
          range.setFormula('=SUM(${r1.addressLocal}:${r2.addressLocal})');
          range.cellStyle = styleIncome;
          x++;
        });
      });
      iSoI++;
    });
  }
}
