import 'dart:ffi';

import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/enums.dart';

class Posting {
  String? id;
  PostingType? postingType;
  DateTime? date;
  Float? amount;
  String? title;
  String? description;
  Account? account;
  Category? category;

  Posting({
    this.id,
    this.postingType,
    this.date,
    this.amount,
    this.title,
    this.description,
    this.account,
    this.category,
  });
}
