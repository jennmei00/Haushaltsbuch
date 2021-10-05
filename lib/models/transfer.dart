import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';

class Transfer {
  String? id;
  DateTime? date;
  Float? betrag;
  String? beschreibung;
  Account? account1;
  Account? account2;

  Transfer({
    this.id,
    this.date,
    this.betrag,
    this.beschreibung,
    this.account1,
    this.account2,
  });
}
