import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:haushaltsbuch/models/account_category.dart';

class Account {
  String? id;
  String? bezeichnung;
  String? beschreibung;
  Float? kontostand;
  Color? color;
  String? symbol; //Datentyp??
  AccountCategory? accountCategory;

  Account({
    this.id,
    this.bezeichnung,
    this.beschreibung,
    this.kontostand,
    this.color,
    this.symbol,
    this.accountCategory,
  });
}
