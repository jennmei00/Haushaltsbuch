import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class Account {
  String? id;
  String? title;
  String? description;
  double? bankBalance;
  Color? color;
  String? symbol; //Datentyp??
  AccountType? accountType;

  Account({
    this.id,
    this.title,
    this.description,
    this.bankBalance,
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
    map['Color'] =
        this.color == null ? Colors.black : this.color!.value.toString();
    map['Symbol'] = this.symbol;
    map['AccountTypeID'] =
        this.accountType == null ? '99' : this.accountType!.id;
    return map;
  }

  List<Account> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Account> list = [];
    mapList.forEach((element) async {
      Account account = await fromDB(element);
      list.add(account);
    });
    return list;
  }

  Future<Account> fromDB(Map<String, dynamic> data) async {
    Account account = Account(
      id: data['ID'],
      title: data['Title'],
      description: data['Description'],
      bankBalance: data['BankBalance'],
      color: data['Color'] == null
          ? Colors.black
          : Color(int.parse(data['Color'])),
      symbol: data['Symbol'],
      accountType: AccountType().fromDB(await DBHelper.getOneData('AccountType',
          where: "ID = '${data['AccountTypeID']}'")),
    );
    return account;
  }
}
