import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class Transfer {
  String? id;
  DateTime? date;
  Float? amount;
  String? description;
  Account? accountFrom;
  Account? accountTo;

  Transfer({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.accountFrom,
    this.accountTo,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Date'] = this.date;
    map['Amount'] = this.amount;
    map['Description'] = this.description;
    map['AccountFromID'] = this.accountFrom!.id;
    map['AccountToID'] = this.accountTo!.id;
    return map;
  }

  List<Transfer> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Transfer> list = [];
    mapList.forEach((element) async {
      Transfer transfer = await fromDB(element);
      list.add(transfer);
    });
    return list;
  }

  Future<Transfer> fromDB(Map<String, dynamic> data) async {
    Transfer transfer = Transfer(
      id: data['ID'],
      date: data['Date'],
      description: data['Description'],
      amount: data['Amount'],
      accountFrom: await Account().fromDB(await DBHelper.getOneData('Account',
          where: 'ID = ${data['AccountFromID']}')),
      accountTo: await Account().fromDB(await DBHelper.getOneData('Account',
          where: 'ID = ${data['AccountToID']}')),
    );
    return transfer;
  }
}
