import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/standing_order.dart';

class Transfer {
  String? id;
  DateTime? date;
  double? amount;
  String? description;
  String? accountFromName;
  String? accountToName;
  Account? accountFrom;
  Account? accountTo;
  bool? isStandingOrder;
  StandingOrder? standingOrder;

  Transfer({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.accountFromName,
    this.accountToName,
    this.accountFrom,
    this.accountTo,
    this.isStandingOrder,
    this.standingOrder,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Date'] = this.date!.toIso8601String();
    map['Amount'] = this.amount;
    map['Description'] = this.description;
    map['AccountFromID'] =
        this.accountFrom == null ? null : this.accountFrom!.id;
    map['AccountToID'] = this.accountTo == null ? null : this.accountTo!.id;
    map['AccountFromName'] = this.accountFromName;
    map['AccountToName'] = this.accountToName;
    map['IsStandingOrder'] = this.isStandingOrder == null
        ? false
        : this.isStandingOrder == true
            ? 1
            : 0;
    map['StandingOrderID'] =
        this.standingOrder == null ? '' : this.standingOrder?.id;
    return map;
  }

  List<Transfer> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Transfer> list = [];
    mapList.forEach((element) {
      Transfer transfer = fromDB(element);
      list.add(transfer);
    });
    return list;
  }

  Transfer fromDB(Map<String, dynamic> data) {
    Transfer transfer = Transfer(
      id: data['ID'],
      date: DateTime.parse(data['Date']),
      description: data['Description'],
      amount: data['Amount'],
      accountFrom: data['AccountFromID'] == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == data['AccountFromID']),
      accountTo: data['AccountToID'] == null
          ? null
          : AllData.accounts
              .firstWhere((element) => element.id == data['AccountToID']),
      accountFromName: data['AccountFromName'],
      accountToName: data['AccountToName'],
      isStandingOrder: data['IsStandingOrder'] == null
          ? false
          : data['IsStandingOrder'] == 0
              ? false
              : true,
      standingOrder: data['StandingOrderID'] == '' || data['StandingOrderID'] == null
          ? null
          : AllData.standingOrders
              .firstWhere((element) => element.id == data['StandingOrderID'], orElse: () => StandingOrder(id: 'NULL')),
    );
    if(transfer.standingOrder != null)
      if(transfer.standingOrder!.id == 'NULL')
        transfer.standingOrder = null;
    return transfer;
  }
}
