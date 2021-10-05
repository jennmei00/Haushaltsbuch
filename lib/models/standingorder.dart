import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';

class Standingorder {
  String? id;
  Buchungsart? buchungsart;
  DateTime? beginn;
  Repetition? repetition;
  Float? betrag;
  String? bezeichnung;
  String? beschreibung;
  Category? category;
  Account? account;

  Standingorder({
    this.id,
    this.buchungsart,
    this.beginn,
    this.repetition,
    this.betrag,
    this.bezeichnung,
    this.beschreibung,
    this.category,
    this.account,
  });
}
