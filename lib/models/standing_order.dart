import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';

class StandingOrder {
  String? id;
  PostingType? postingType;
  DateTime? begin;
  Repetition? repetition;
  Float? amount;
  String? title;
  String? description;
  Category? category;
  Account? account;

  StandingOrder({
    this.id,
    this.postingType,
    this.begin,
    this.repetition,
    this.amount,
    this.title,
    this.description,
    this.category,
    this.account,
  });
}
