import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/help_methods.dart';

class StandingOrder {
  String? id;
  PostingType? postingType;
  DateTime? begin;
  DateTime? end;
  Repetition? repetition;
  double? amount;
  String? title;
  String? description;
  Category? category;
  Account? account;
  Account? accountTo;

  StandingOrder({
    this.id,
    this.postingType,
    this.begin,
    this.end,
    this.repetition,
    this.amount,
    this.title,
    this.description,
    this.category,
    this.account,
    this.accountTo,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['PostingType'] = this.postingType!.index;
    map['Begin'] = this.begin!.toIso8601String();
    map['End'] = this.end == null ? null : this.end!.toIso8601String();
    map['Repetition'] = formatRepetition(this.repetition!);
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['Amount'] = this.amount;
    map['CategoryID'] = this.category == null ? null : this.category!.id;
    map['AccountID'] = this.account == null ? null : this.account!.id;
    map['AccountToID'] = this.accountTo == null ? null : this.accountTo!.id;
    return map;
  }

  List<StandingOrder> listFromDB(List<Map<String, dynamic>> mapList) {
    List<StandingOrder> list = [];
    mapList.forEach((element) {
      StandingOrder standingOrder = fromDB(element);
      list.add(standingOrder);
    });
    return list;
  }

  StandingOrder fromDB(Map<String, dynamic> data) {
    StandingOrder standingOrder = StandingOrder(
      id: data['ID'],
      postingType: data['PostingType'] == null
          ? null
          : PostingType.values[data['PostingType'] as int],
      begin: DateTime.parse(data['Begin']),
      end: data['End'] == null ? null : DateTime.parse(data['End']),
      repetition: getRepetitionFromString(data['Repetition']),
      title: data['Title'],
      description: data['Description'],
      amount: data['Amount'],
      category: data['CategoryID'] == null
          ? null
          : AllData.categories
              .firstWhere((element) => element.id == data['CategoryID']),
      account: data['AccountID'] == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == data['AccountID']),
      accountTo: data['AccountToID'] == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == data['AccountToID']),
    );
    return standingOrder;
  }
}
