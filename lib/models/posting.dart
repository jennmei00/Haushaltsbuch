import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';

class Posting {
  String? id;
  Buchungsart? buchungsart;
  DateTime? date;
  Float? betrag;
  String? bezeichnung;
  String? beschreibung;
  Account? account;
  Category? category;

  Posting({
    this.id,
    this.buchungsart,
    this.date,
    this.betrag,
    this.bezeichnung,
    this.beschreibung,
    this.account,
    this.category,
  });
}
