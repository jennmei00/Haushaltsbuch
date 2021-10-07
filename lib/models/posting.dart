import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class Posting {
  String? id;
  PostingType? postingType;
  DateTime? date;
  Float? amount;
  String? title;
  String? description;
  Account? account;
  Category? category;

  Posting({
    this.id,
    this.postingType,
    this.date,
    this.amount,
    this.title,
    this.description,
    this.account,
    this.category,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['PostingType'] = this.postingType;
    map['Date'] = this.date;
    map['Amount'] = this.amount;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['AccountID'] = this.account!.id;
    map['CategoryID'] = this.category!.id;
    return map;
  }

  List<Posting> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Posting> list = [];
    mapList.forEach((element) async {
      Posting posting = await fromDB(element);
      list.add(posting);
    });
    return list;
  }

  Future<Posting> fromDB(Map<String, dynamic> data) async {
    Posting posting = Posting(
      id: data['ID'],
      postingType: data['PostingType'],
      date: data['Date'],
      amount: data['Amount'],
      title: data['Title'],
      description: data['Description'],
      account: await Account().fromDB(await DBHelper.getOneData(
          'Account',
          where: 'ID = $account')),
      category: Category().fromDB(await DBHelper.getOneData(
          'Category',
          where: 'ID = ${data['CategoryID']}')),
    );
    return posting;
  }
}
