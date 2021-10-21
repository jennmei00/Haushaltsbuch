import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_category.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/standing_order_posting.dart';
import 'package:haushaltsbuch/models/transfer.dart';

class AllData {
  //If the keyword "late" is used, you have to initialize it later, but before you use it.
  //Otherwise it throws an Error!
  //So you don't have to add "?" and the variable cannot be null.

  static late List<Category> categires;
  static late List<AccountCategory> accountCategories;
  static late List<Account> accounts;
  static late List<Posting> postings;
  static late List<Transfer> transfers;
  static late List<StandingOrder> standingOrders;
  static late List<StandingOrderPosting> standingOrderPostings;
}