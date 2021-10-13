import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account_category.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class Account {
  String? id;
  String? title;
  String? description;
  double? bankBalance;
  Color? color;
  String? symbol; //Datentyp??
  AccountCategory? accountCategory;

  Account({
    this.id,
    this.title,
    this.description,
    this.bankBalance,
    this.color,
    this.symbol,
    this.accountCategory,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['BankBalance'] = this.bankBalance;
    map['Color'] = this.color!.value.toString();
    map['Symbol'] = this.symbol;
    map['AccountCategoryID'] =
        this.accountCategory == null ? '99' : this.accountCategory!.id;
    return map;
  }

  Future<List<Account>> listFromDB(List<Map<String, dynamic>> mapList) async {
    List<Account> list = [];
    mapList.forEach((element) async {
      Account account = await fromDB(element);
      print(account);
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
      // accountCategory: AccountCategory().fromDB(await DBHelper.getOneData(
      //     'AccountCategory',
      //     where: 'ID = ${data['AccountCategoryID']}')),
    );
    return account;
  }
}
