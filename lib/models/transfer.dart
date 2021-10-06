import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';

class Transfer {
  String? id;
  DateTime? date;
  Float? amount;
  String? descrpiton;
  Account? accountFrom;
  Account? accountTo;

  Transfer({
    this.id,
    this.date,
    this.amount,
    this.descrpiton,
    this.accountFrom,
    this.accountTo,
  });
}
