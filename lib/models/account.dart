import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/all_data.dart';

class Account {
  String? id;
  String? title;
  String? description;
  double? bankBalance;
  double? initialBankBalance;
  DateTime? creationDate;
  Color? color;
  String? symbol;
  AccountType? accountType;

  Account({
    this.id,
    this.title,
    this.description,
    this.bankBalance,
    this.initialBankBalance,
    this.creationDate,
    this.color,
    this.symbol,
    this.accountType,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['BankBalance'] = this.bankBalance;
    map['InitialBankBalance'] = this.initialBankBalance;
    map['CreationDate'] = this.creationDate!.toIso8601String();
    map['Color'] =
        this.color == null ? Colors.black : this.color!.toARGB32().toString();
    map['Symbol'] = this.symbol;
    map['AccountTypeID'] =
        this.accountType == null ? '99' : this.accountType!.id;
    return map;
  }

  List<Account> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Account> list = [];
    mapList.forEach((element) {
      Account account = fromDB(element);
      list.add(account);
    });
    return list;
  }

  Account fromDB(Map<String, dynamic> data) {
    Account account = Account(
      id: data['ID'],
      title: data['Title'],
      description: data['Description'],
      bankBalance: data['BankBalance'],
      initialBankBalance: data['InitialBankBalance'],
      creationDate: DateTime.parse(data['CreationDate']),
      color: data['Color'] == null
          ? Colors.black
          : Color(int.parse(data['Color'])),
      symbol: data['Symbol'],
      accountType: AllData.accountTypes
          .firstWhere((element) => element.id == data['AccountTypeID']),
    );
    return account;
  }
}
