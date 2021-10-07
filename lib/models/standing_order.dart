import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class StandingOrder {
  String? id;
  PostingType? postingType;
  DateTime? begin;
  Repetition? repetition;
  Float? amount;
  String? title;
  String? description;
  Category? category;
  Account? account;

  StandingOrder({
    this.id,
    this.postingType,
    this.begin,
    this.repetition,
    this.amount,
    this.title,
    this.description,
    this.category,
    this.account,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['PostingType'] = this.postingType!.index;
    map['Begin'] = this.begin;
    map['Repetition'] = this.repetition;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['Amount'] = this.amount;
    map['CategoryID'] = this.category!.id;
    map['AccountID'] = this.account!.id;
    return map;
  }

  List<StandingOrder> listFromDB(List<Map<String, dynamic>> mapList) {
    List<StandingOrder> list = [];
    mapList.forEach((element) async {
      StandingOrder standingOrder = await fromDB(element);
      list.add(standingOrder);
    });
    return list;
  }

  Future<StandingOrder> fromDB(Map<String, dynamic> data) async {
    StandingOrder standingOrder = StandingOrder(
      id: data['ID'],
      postingType: PostingType.values[data['PostingType'] as int],
      begin: data['Begin'],
      repetition: data['Repetition'],
      title: data['Title'],
      description: data['Description'],
      amount: data['Amount'],
      category: Category().fromDB(await DBHelper.getOneData('Category',
          where: 'ID = ${data['CategoryID']}')),
      account: await Account().fromDB(await DBHelper.getOneData('Account',
          where: 'ID = ${data['AccountID']}')),
    );
    return standingOrder;
  }
}
