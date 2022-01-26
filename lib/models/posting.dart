import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
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
  bool? isStandingOrder;
  StandingOrder? standingOrder;

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
    this.isStandingOrder,
    this.standingOrder,
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
    map['IsStandingOrder'] = this.isStandingOrder == null
        ? false
        : this.isStandingOrder == true
            ? 1
            : 0;
    map['StandingOrderID'] =
        this.standingOrder == null ? '' : this.standingOrder?.id;
    return map;
  }

  List<Posting> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Posting> list = [];
    mapList.forEach((element)  {
      Posting posting =  fromDB(element);
      list.add(posting);
    });
    return list;
  }

  Posting fromDB(Map<String, dynamic> data) {
    Posting posting = Posting(
      id: data['ID'],
      postingType: data['PostingType'] == null
          ? null
          : PostingType.values[data['PostingType'] as int],
      date: DateTime.parse(data['Date']),
      amount: data['Amount'],
      title: data['Title'],
      description: data['Description'],
      account: data['AccountID'] == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == data['AccountID']),
      //     : await Account().fromDB(await DBHelper.getOneData('Account',
      //         where: "ID = '${data['AccountID']}'")),
      accountName: data['AccountName'],
      category: AllData.categories
          .firstWhere((element) => element.id == data['CategoryID']),
      // category: Category().fromDB(await DBHelper.getOneData('Category',
      //     where: "ID = '${data['CategoryID']}'")),
      isStandingOrder: data['IsStandingOrder'] == null
          ? false
          : data['IsStandingOrder'] == 0
              ? false
              : true,
      standingOrder: data['StandingOrderID'] == ''
          ? null
          : AllData.standingOrders
              .firstWhere((element) => element.id == data['StandingOrderID']),
      // : await StandingOrder().fromDB(await DBHelper.getOneData(
      //     'StandingOrder',
      //     where: "ID = '${data['StandingOrderID']}'")),
    );
    return posting;
  }
}
