import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class StandingOrder {
  String? id;
  PostingType? postingType;
  DateTime? begin;
  Repetition? repetition;
  double? amount;
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
    map['Begin'] = this.begin!.toIso8601String();
    map['Repetition'] = this.repetition;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['Amount'] = this.amount;
    map['CategoryID'] = this.category == null ? null : this.category!.id;
    map['AccountID'] = this.account == null ? null : this.account!.id;
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
      postingType: data['PostingType'] == null
          ? null
          : PostingType.values[data['PostingType'] as int],
      begin: DateTime.parse(data['Begin']),
      repetition: data['Repetition'],
      title: data['Title'],
      description: data['Description'],
      amount: data['Amount'],
      category: data['CategoryID'] == null
          ? null
          : Category().fromDB(await DBHelper.getOneData('Category',
              where: "ID = '${data['CategoryID']}'")),
      account: data['AccountID'] == null
          ? null
          :  await Account().fromDB(await DBHelper.getOneData('Account',
              where: "ID = '${data['AccountID']}'")),
    );
    return standingOrder;
  }
}
