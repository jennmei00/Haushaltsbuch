import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_type.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/auth_provider.dart';

class AllData {
  //If the keyword "late" is used, you have to initialize it later, but before you use it.
  //Otherwise it throws an Error!
  //So you don't have to add "?" and the variable cannot be null.

  static late List<Category> categories;
  static late List<AccountType> accountTypes;
  static late List<Account> accounts;
  static late List<Posting> postings;
  static late List<Transfer> transfers;
  static late List<StandingOrder> standingOrders;
  static AuthProvider? authProvider;
}
