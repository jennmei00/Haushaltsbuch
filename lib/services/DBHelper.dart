import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class DBHelper {
  static sql.Database? _database;
  static int versionNumber = 2;

  //Open Database
  static Future<sql.Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    print(dbPath);
    return _database ??= await sql.openDatabase(
        path.join(dbPath, 'Haushaltsbuch.db'),
        onCreate: _createTables,
        onUpgrade: _upgradeTables,
        version: versionNumber);
  }

//Delete Database
  static Future<void> deleteDatabse() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase('$dbPath/Haushaltsbuch.db');
    _database = null;
  }

  //Functions
  //GETDATA
  static Future<List<Map<String, dynamic>>> getData(String table,
      {List<String>? columns, String? where, String? orderBy}) async {
    final db = await DBHelper.openDatabase();
    return db.transaction((txn) async {
      return await txn.query(table,
          columns: columns, where: where, orderBy: orderBy);
    });
  }

  static Future<Map<String, dynamic>> getOneData(String table,
      {List<String>? columns, String? where, String? orderBy}) async {
    List<Map<String, dynamic>> _data =
        await getData(table, columns: columns, where: where, orderBy: orderBy);

    return _data[0];
  }

  //INSERT
  static Future<void> multipleInsert(
      String table, List<Map<String, dynamic>> dataList) async {
    final db = await DBHelper.openDatabase();
    sql.Batch batch = db.batch();
    dataList.forEach((Map<String, dynamic> data) {
      batch.insert(table, data);
    });
    await batch.commit();
  }

  static Future<void> multipleInsertOrUpdate(String table,
      List<Map<String, dynamic>> dataList, String primaryKey) async {
    final db = await DBHelper.openDatabase();
    sql.Batch batch = db.batch();
    for (var data in dataList) {
      var _primaryKeyValue = data[primaryKey];
      int _count = await count(table,
          where: "WHERE $primaryKey = '${data[primaryKey]}'");
      if (_count > 0) {
        data.removeWhere((k, v) => k == primaryKey);
        batch.update(table, data, where: "$primaryKey = '$_primaryKeyValue'");
      } else {
        batch.insert(table, data);
      }
    }
    await batch.commit();
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.openDatabase();
    sql.Batch batch = db.batch();
    batch.insert(table, data);
    await batch.commit();
  }

  static Future<void> update(String table, Map<String, dynamic> data,
      {String? where}) async {
    final db = await DBHelper.openDatabase();
    sql.Batch batch = db.batch();
    batch.update(table, data, where: where);
    await batch.commit();
  }

  //DELETE
  static Future<void> delete(String table, {String? where}) async {
    final db = await DBHelper.openDatabase();
    sql.Batch batch = db.batch();
    batch.delete(table, where: where);
    await batch.commit();
  }

  //COUNT
  static Future<int> count(String table, {String where = ''}) async {
    final db = await DBHelper.openDatabase();
    return await db.transaction((txn) async {
      return sql.Sqflite.firstIntValue(await txn.rawQuery(
              'SELECT COUNT(*) FROM $table${where.isNotEmpty ? ' $where' : ''}'))
          as Future<int>;
    });
  }

  //////////COPY - PASTE ----- Muss noch angeschaut und evtl. angepasst werden!
  // //SUM
  // static Future<double> sum(String table, String column,
  //     {String where = ''}) async {
  //   final db = await DBHelper.openDatabase();
  //   return db.transaction((txn) async {
  //     List<Map<String, dynamic>> _result;
  //     if (where != null && where.isNotEmpty) {
  //       _result = await txn
  //           .rawQuery('SELECT SUM($column) As Result FROM $table WHERE $where');
  //     } else {
  //       _result =
  //           await txn.rawQuery('SELECT SUM($column) As Result FROM $table');
  //     }

  //     if (_result != null && _result.length > 0) {
  //       return _result[0]['Result'];
  //     }
  //     return 0;
  //   });
  // }

  // //MAX
  // static Future<int> max(String table, String column,
  //     {String where = ''}) async {
  //   final db = await DBHelper.openDatabase();
  //   return db.transaction((txn) async {
  //     List<Map<String, dynamic>> _result;
  //     if (where != null && where.isNotEmpty) {
  //       _result = await txn
  //           .rawQuery('SELECT MAX($column) As Result FROM $table WHERE $where');
  //     } else {
  //       _result =
  //           await txn.rawQuery('SELECT MAX($column) As Result FROM $table');
  //     }

  //     if (_result != null && _result.length > 0) {
  //       return _result[0]['Result'];
  //     }
  //     return 0;
  //   });
  // }

  //Create Tables
  static Future<void> _createTables(sql.Database db, int version) async {
    //Category
    await db.execute(
        'CREATE TABLE Category(ID TEXT PRIAMRY KEY, Title TEXT, Symbol TEXT, Color TEXT)');

    //AccountType
    await db
        .execute('CREATE TABLE AccountType(ID TEXT PRIAMRY KEY, Title TEXT)');

    //Account
    await db.execute(
        'CREATE TABLE Account(ID TEXT PRIMARY KEY, Title TEXT, Description TEXT, BankBalance REAL,' +
            'Color TEXT, Symbol TEXT, AccountTypeID TEXT, CreationDate TEXT, InitialBankBalance REAL, ' +
            'FOREIGN KEY(AccountTypeID) REFERENCES AccountType(ID))');

    //Posting
    await db.execute(
        'CREATE TABLE Posting(ID TEXT, PostingType INTEGER, Date TEXT, Amount REAL, ' +
            'Title TEXT, Description TEXT, AccountName TEXT, AccountID TEXT, CategoryID TEXT, StandingOrderID TEXT, IsStandingOrder BOOLEAN, ' +
            'FOREIGN KEY(AccountID) REFERENCES Account(ID), FOREIGN KEY(StandingOrderID) REFERENCES StandingOrder(ID), ' +
            'FOREIGN KEY(CategoryID) REFERENCES Category(ID))');

    //Transfer
    await db.execute(
        'CREATE TABLE Transfer(ID TEXT, Date TEXT, Amount REAL, Description TEXT, AccountFromName TEXT, AccountToName TEXT,' +
            'AccountFromID TEXT, AccountToID TEXT, FOREIGN KEY(AccountFromID) REFERENCES Account(ID), ' +
            'FOREIGN KEY(AccountToID) REFERENCES Account(ID))');

    //StandingOrder
    await db.execute(
        'CREATE TABLE StandingOrder(ID TEXT, PostingType INTEGER, Begin TEXT, End TEXT, Repetition INTEGER, ' +
            'Amount REAL, Title TEXT, Description TEXT, AccountID TEXT, CategoryID TEXT, ' +
            'FOREIGN KEY(AccountID) REFERENCES Account(ID), FOREIGN KEY(CategoryID) REFERENCES Category(ID))');

    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Sparkonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Girokonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Tagesgeldkonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Festgeldkonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Kreditkartenkonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Bargeldkonto')");
    await db.execute(
        "INSERT INTO AccountType VALUES('${Uuid().v1()}', 'Sonstiges Konto')");
    await db.execute(
        "INSERT INTO Category VALUES('default', 'Sonstiges', 'assets/icons/category_icons/money-2.png', ${Color(0xff00695c).value.toString()})"); //${Color(0xff00695c).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Handyvertrag', 'assets/icons/category_icons/smartphone.png', ${Color(0xff616161).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Versicherung', 'assets/icons/category_icons/insurance.png', ${Color(0xff00838f).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Lebensmittel', 'assets/icons/category_icons/diet.png', ${Color(0xff558b2f).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Drogerie', 'assets/icons/category_icons/shampoo.png', ${Color(0xFFad1457).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Tanken', 'assets/icons/category_icons/gas-station.png', ${Color(0xff616161).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Kleidung', 'assets/icons/category_icons/wardrobe.png', ${Color(0xFFad1457).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Auto', 'assets/icons/category_icons/car.png', ${Color(0xff1565c0).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Wohnen', 'assets/icons/category_icons/living-room.png', ${Color(0xffff8f00).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Freizeit', 'assets/icons/category_icons/park.png', ${Color(0xff2e7d32).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Miete', 'assets/icons/category_icons/contract.png', ${Color(0xff00838f).value.toString()})");
    await db.execute(
        "INSERT INTO Category VALUES('${Uuid().v1()}', 'Lohn', 'assets/icons/category_icons/salary.png', ${Color(0xff9e9d24).value.toString()})");

    await _upgradeTables(db, 1, versionNumber);
  }

  // Upgrade Tables
  static Future<void> _upgradeTables(
      sql.Database db, int oldVersion, int newVersion) async {
    // ab Version 2
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE StandingOrder ADD AccountToID TEXT');
        await db.execute('ALTER TABLE Transfer ADD StandingOrderID TEXT');
        await db.execute('ALTER TABLE Transfer ADD IsStandingOrder BOOLEAN');
        // await db.execute('ALTER TABLE StandingOrder ADD FOREIGN KEY(AccountToID) REFERENCES Account(ID)');
      } catch (ex) {
        FileHelper()
            .writeAppLog(AppLog(ex.toString(), 'Upgrade Tables Version 2'));

        print(ex);
      }
    }
  }
}
