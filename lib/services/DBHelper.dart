import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static sql.Database? _database;

  //Open Database
  static Future<sql.Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return _database ??=
        await sql.openDatabase(path.join(dbPath, 'Haushaltsbuch.db'),
            onCreate: _createTables,
            //onUpgrade: _upgradeTables,
            version: 1);
  }

//Delete Database
  static Future<void> deleteDatabse() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase('$dbPath/Haushaltsbuch.db');
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

    // if (_data != null && _data.length > 0) {
    return _data[0];
    // }
    // return null;
  }

  //INSERT
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
    // //Tabellenname
    // await db.execute(
    //     'CREATE TABLE ...(...TEXT PRIMARY KEY, ... TEXT/INTEGER/BOOLEAN/BLOB)');
    //Beispieltabelle
    await db.execute(
        'CREATE TABLE Tabelle1(Tabelle1GUID TEXT PRIMARY KEY, Variable1 TEXT, Variable2 INTEGER)');

    //Kategorie
    await db.execute(
        'CREATE TABLE Kategorie(KategorieID TEXT PRIAMRY KEY, Bezeichnung TEXT, Symbol BLOB, Farbe TEXT)');

    //..._id TEXT, FOREIGN KEY(..._id) REFERENCES tabelle(id)

    //Kontokategorie
    await db.execute(
        'CREATE TABLE Kontokategorie(KontokategorieID TEXT PRIAMRY KEY, Bezeichnung TEXT)');

    //Konto
    await db.execute(
        'CREATE TABLE Konto(KontoID TEXT PRIMARY KEY, Bezeichnung TEXT, Beschreibung TEXT, Kontostand REAL,' +
            'Farbe TEXT, Symbol BLOB, KontokategorieID TEXT, FOREIGN KEY(KontokategorieID) REFERENCES Kontokategorie(KontokategorieID))');

    //Buchung
    await db.execute(
        'CREATE TABLE Buchung(BuchungID TEXT, Buchungsart INTEGER, Datum TEXT, Betrag REAL, ' +
            'Bezeichnung TEXT, Beschreibung TEXT, KontoID TEXT, KategorieID TEXT, FOREIGN KEY(KontoID) REFERENCES Konto(KontoID), ' +
            'FOREIGN KEY(KategorieID) REFERENCES Kategorie(KategorieID))');

    //Umbuchung
    await db.execute(
        'CREATE TABLE Umbuchung(UmbuchungID TEXT, Datum TEXT, Betrag REAL, Beschreibung TEXT, ' +
            'Konto1ID TEXT, Konto2ID TEXT, FOREIGN KEY(Konto1ID) REFERENCES Konto(KontoID), ' +
            'FOREIGN KEY(Konto2ID) REFERENCES Konto(Konto2ID))');

    //Dauerauftrag
    await db.execute(
        'CREATE TABLE Dauerauftrag(DauerauftragID TEXT, Buchungsart INTEGER, Beginn TEXT, Wiederholung INTEGER, ' +
            'Betrag REAL, Bezeichnung TEXT, Beschreibung TEXT, KontoID TEXT, KategorieID TEXT, ' +
            'FOREIGN KEY(KontoID) REFERENCES Konto(KontoID), FOREIGN KEY(KategorieID) REFERENCES Kategorie(KategorieID))');

    //Dauerauftragsbuchung
    await db.execute(
        'CREATE TABLE Dauerauftragsbuchung(DauerauftragsbuchungID TEXT, Datum TEXT, DauerauftragID TEXT, ' +
            'FOREIGN KEY(DauerauftragID) REFERENCES Dauerauftrag(DauerauftragID))');
  }

  /////////////COPY - PASTE ---- Verstehe ich nicht ganz (wenn ich Tabelle Upgrade, Lösche ich Database und create Tabellen neu 'O')
  //Upgrade Tables
  // static Future<void> _upgradeTables(
  //     sql.Database db, int oldVersion, int newVersion) async {
  //   // //ab Version 2
  //   // if(oldVersion < 2 && newVersion == 2) {
  //   //   try{
  //   //     db.execute('ALTER TABLE Auftraege ');
  //   //   }
  //   //   catch(e) {
  //   //     print(e);
  //   //   }
  //   // }
  // }
}
