import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';

class Transfer {
  String? id;
  DateTime? date;
  double? amount;
  String? description;
  String? accountFromName;
  String? accountToName;
  Account? accountFrom;
  Account? accountTo;

  Transfer({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.accountFromName,
    this.accountToName,
    this.accountFrom,
    this.accountTo,
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
    );
    return transfer;
  }
}
