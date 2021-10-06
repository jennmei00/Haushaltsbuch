import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:haushaltsbuch/models/account_category.dart';

class Account {
  String? id;
  String? title;
  String? description;
  Float? bankBalance;
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
}
