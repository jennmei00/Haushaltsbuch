import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class Posting {
  String? id;
  PostingType? postingType;
  DateTime? date;
  double? amount;
  String? title;
  String? description;
  Account? account;
  String? accountName;
  Category? category;

  Posting({
    this.id,
    this.postingType,
    this.date,
    this.amount,
    this.title,
    this.description,
    this.account,
    this.accountName,
    this.category,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['PostingType'] =
        this.postingType == null ? null : this.postingType!.index;
    map['Date'] = this.date!.toIso8601String();
    map['Amount'] = this.amount;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['AccountID'] = this.account == null ? null : this.account!.id;
    map['AccountName'] = this.accountName;
    map['CategoryID'] = this.category == null ? null : this.category!.id;
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
      postingType: data['PostingType'] == null
          ? null
          : PostingType.values[data['PostingType'] as int],
      date: DateTime.parse(data['Date']),
      amount: data['Amount'],
      title: data['Title'],
      description: data['Description'],
      account: await Account().fromDB(
          await DBHelper.getOneData('Account', where: "ID = $account'")),
      accountName: data['AccountName'],
      category: Category().fromDB(await DBHelper.getOneData('Category',
          where: "ID = ${data['CategoryID']}'")),
    );
    return posting;
  }
}
