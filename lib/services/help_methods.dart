import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
import 'package:uuid/uuid.dart';

String formatDate(DateTime date, BuildContext context) {
  initializeDateFormatting();
  var formattedDate =
      DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
          .format(date);
  return '$formattedDate';
}

String formatDateMY(DateTime date, BuildContext context) {
  initializeDateFormatting();

  var formattedDate =
      DateFormat.yMMMM(Localizations.localeOf(context).languageCode)
          .format(date);
  return '$formattedDate';
}

DateFormat weeklyDateFormat(BuildContext context) {
  initializeDateFormatting();
  return DateFormat("'${'week-of'.i18n()}'\n dd.MMM y",
      Localizations.localeOf(context).languageCode);
}

String formatCurrency(double amount, {String locale = "de"}) {
  var formattedCurrency =
      NumberFormat.currency(locale: locale, symbol: "${Globals.currency.symbol}")
          .format(amount);
  return '$formattedCurrency';
}

NumberFormat currencyNumberFormat() {
  return NumberFormat.currency(
      locale: "de", symbol: "${Globals.currency.symbol}");
}

String formatTextFieldCurrency(double amount, {locale = "de"}) {
  return NumberFormat("##0.00", locale).format(amount);
}

String formatRepetition(Repetition repetition) {
  if (repetition == Repetition.monthly) {
    return 'monthly'.i18n();
  } else if (repetition == Repetition.weekly) {
    return 'weekly'.i18n();
  } else if (repetition == Repetition.yearly) {
    return 'yearly'.i18n();
  } else if (repetition == Repetition.quarterly) {
    return 'quarterly'.i18n();
  } else if (repetition == Repetition.halfYearly) {
    return 'half-yearly'.i18n();
  } else {
    return '';
  }
}

Color getAccountColorFromAccountName(String accountName) {
  Account ac = AllData.accounts.firstWhere(
      (element) => element.title == accountName,
      orElse: () => Account(color: Color(0xff616161)));
  Color accountColor = ac.color!;
  return accountColor;
}

Repetition getRepetitionFromString(String repetition) {
  if (repetition == 'monthly'.i18n()) {
    return Repetition.monthly;
  } else if (repetition == 'weekly'.i18n()) {
    return Repetition.weekly;
  } else if (repetition == 'yearly'.i18n()) {
    return Repetition.yearly;
  } else if (repetition == 'quarterly'.i18n()) {
    return Repetition.quarterly;
  } else if (repetition == 'half-yearly'.i18n()) {
    return Repetition.halfYearly;
  } else {
    return Repetition.monthly;
  }
}

Color getLightColorFromDarkColor(Color color) {
  ColorSwatch<Object> darkColorKey = Globals.customSwatchDarkMode.keys
      .firstWhere((element) => element.value == color.value);

  Color lightColor = Globals.customSwatchLightMode.keys.firstWhere((element) =>
      Globals.customSwatchLightMode[element] ==
      Globals.customSwatchDarkMode[darkColorKey]);

  return lightColor;
}

Color getDarkColorFromLightColor(Color color) {
  ColorSwatch<Object> lightColorKey = Globals.customSwatchLightMode.keys
      .firstWhere((element) => element.value == color.value);

  Color darkColor = Globals.customSwatchDarkMode.keys.firstWhere((element) =>
      Globals.customSwatchDarkMode[element] ==
      Globals.customSwatchLightMode[lightColorKey]);

  return darkColor;
}

Color getColor(Color color) {
  Color lightColor = color;
  if (Globals.isDarkmode) {
    return getDarkColorFromLightColor(lightColor);
  } else {
    return lightColor;
  }
}

Color getColorToSave(Color color) {
  if (Globals.isDarkmode) {
    return getLightColorFromDarkColor(color);
  } else {
    return color;
  }
}

DateTime getMondayOfWeek(DateTime date) {
  DateTime monday;

  switch (Jiffy(date).day) {
    case 1:
      monday = Jiffy(date).subtract(days: 6).dateTime;
      break;
    case 2:
      monday = date;
      break;
    case 3:
      monday = Jiffy(date).subtract(days: 1).dateTime;
      break;
    case 4:
      monday = Jiffy(date).subtract(days: 2).dateTime;
      break;
    case 5:
      monday = Jiffy(date).subtract(days: 3).dateTime;
      break;
    case 6:
      monday = Jiffy(date).subtract(days: 4).dateTime;
      break;
    case 7:
      monday = Jiffy(date).subtract(days: 5).dateTime;
      break;
    default:
      monday = date;
  }

  return monday;
}

String getAccountTypeInLanguage(String title) {
  String text = '';
  switch (title) {
    case 'Sparkonto':
      text = 'saving-account'.i18n();
      break;
    case 'Girokonto':
      text = 'checking-account'.i18n();
      break;
    case 'Tagesgeldkonto':
      text = 'call-money-account'.i18n();
      break;
    case 'Festgeldkonto':
      text = 'fixed-deposit-account'.i18n();
      break;
    case 'Kreditkartenkonto':
      text = 'credit-card-account'.i18n();
      break;
    case 'Bargeldkonto':
      text = 'cash-account'.i18n();
      break;
    case 'Sonstiges Konto':
      text = 'other-account'.i18n();
      break;
    default:
      text = title;
  }
  return text;
}

String getDefaultCategoriesInLanguage(String title) {
  String text = '';
  switch (title) {
    case 'Auto':
      text = 'category-car'.i18n();
      break;
    case 'Drogerie':
      text = 'category-drugstore'.i18n();
      break;
    case 'Freizeit':
      text = 'category-spare-time'.i18n();
      break;
    case 'Handyvertrag':
      text = 'category-mobile-contract'.i18n();
      break;
    case 'Kleidung':
      text = 'category-clothing'.i18n();
      break;
    case 'Lebensmittel':
      text = 'category-food'.i18n();
      break;
    case 'Lohn':
      text = 'category-salary'.i18n();
      break;
    case 'Miete':
      text = 'category-rent'.i18n();
      break;
    case 'Sonstiges':
      text = 'category-others'.i18n();
      break;
    case 'Tanken':
      text = 'category-fual'.i18n();
      break;
    case 'Versicherung':
      text = 'category-insurance'.i18n();
      break;
    case 'Wohnen':
      text = 'category-living'.i18n();
      break;
    default:
      text = title;
  }
  return text;
}

void updateStandingOrders(BuildContext context, bool appResumed) {
  AllData.postings.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));
  AllData.transfers.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));

  bool isUpdatedPostings = false;
  bool isUpdatedTransfers = false;

  isUpdatedPostings = _updatePostings(isUpdatedPostings, appResumed);
  isUpdatedTransfers = _updateTransfers(isUpdatedTransfers, appResumed);

  if (appResumed && (isUpdatedPostings || isUpdatedTransfers))
    Phoenix.rebirth(context);
  else if (!appResumed && (isUpdatedPostings || isUpdatedTransfers)) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Buchungen aktualisiert'),
            content: Text(
                'Es wurden neue Buchungen zu deinen Daueraufträgen hinzugefügt.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          );
        });
  }
}

bool _updatePostings(bool isUpdated, bool appResumed) {
  AllData.standingOrders
      .where((element) => element.postingType != PostingType.transfer)
      .forEach((element) {
    if (element.end != null) {
      if (element.end!.isBefore(DateTime.now())) return;
    }

    Posting? lastPosting;

    try {
      lastPosting = AllData.postings.length == 0
          ? null
          : AllData.postings.lastWhere(((elementPosting) =>
              elementPosting.standingOrder == null
                  ? false
                  : elementPosting.standingOrder?.id == element.id), orElse: () => Posting(id: 'NoPosting'));
    } catch (ex) {
      FileHelper().writeAppLog(AppLog(ex.toString(), 'Update Postings'));

      print('Help Methods _updatePostings $ex');
    }

    if (element.repetition == Repetition.weekly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting(id: 'NoPosting'))
        date = lastPosting.date as DateTime;
      else
        date = element.begin!.subtract(Duration(days: 7));
      Duration difference = DateTime.now().difference(date);
      if (difference.inDays / 7 >= 1) {
        int missing = (difference.inDays / 7).floor();

        for (var i = 0; i < missing; i++) {
          date = date!.add(Duration(days: 7));
          isUpdated = true;
          if (!appResumed) _addPosting(element, date);
        }
      }
    } else if (element.repetition == Repetition.monthly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting())
        date = lastPosting.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addPosting(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 1;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addPosting(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i++;
      }
    } else if (element.repetition == Repetition.quarterly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting())
        date = lastPosting.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addPosting(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 3;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addPosting(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i += 3;
      }
    } else if (element.repetition == Repetition.halfYearly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting())
        date = lastPosting.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addPosting(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 6;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addPosting(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i += 6;
      }
    } else if (element.repetition == Repetition.yearly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting())
        date = lastPosting.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addPosting(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 1;
      while (Jiffy(date).add(years: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addPosting(element, Jiffy(date).add(years: i).dateTime);
        isUpdated = true;
        i++;
      }
    }
  });
  return isUpdated;
}

bool _updateTransfers(bool isUpdated, bool appResumed) {
  AllData.standingOrders
      .where((element) => element.postingType == PostingType.transfer)
      .forEach((element) {
    if (element.end != null) {
      if (element.end!.isBefore(DateTime.now())) return;
    }

    Transfer? lastTransfer;

    try {
      lastTransfer = AllData.transfers.length == 0
          ? null
          : AllData.transfers.lastWhere(((elementTransfer) =>
              elementTransfer.standingOrder == null
                  ? false
                  : elementTransfer.standingOrder?.id == element.id));
    } catch (ex) {
      FileHelper().writeAppLog(AppLog(ex.toString(), 'Update Transfers'));
      print('Help Methods _updateTransfers $ex');
    }

    if (element.repetition == Repetition.weekly) {
      DateTime? date;
      if (lastTransfer != null && lastTransfer != Transfer())
        date = lastTransfer.date as DateTime;
      else
        date = element.begin!.subtract(Duration(days: 7));
      Duration difference = DateTime.now().difference(date);
      if (difference.inDays / 7 >= 1) {
        int missing = (difference.inDays / 7).floor();

        for (var i = 0; i < missing; i++) {
          date = date!.add(Duration(days: 7));
          isUpdated = true;
          if (!appResumed) _addTransfer(element, date);
        }
      }
    } else if (element.repetition == Repetition.monthly) {
      DateTime? date;
      if (lastTransfer != null && lastTransfer != Transfer())
        date = lastTransfer.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addTransfer(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 1;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addTransfer(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i++;
      }
    } else if (element.repetition == Repetition.quarterly) {
      DateTime? date;
      if (lastTransfer != null && lastTransfer != Transfer())
        date = lastTransfer.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addTransfer(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 3;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addTransfer(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i += 3;
      }
    } else if (element.repetition == Repetition.halfYearly) {
      DateTime? date;
      if (lastTransfer != null && lastTransfer != Transfer())
        date = lastTransfer.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addTransfer(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 6;
      while (Jiffy(date).add(months: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addTransfer(element, Jiffy(date).add(months: i).dateTime);
        isUpdated = true;
        i += 6;
      }
    } else if (element.repetition == Repetition.yearly) {
      DateTime? date;
      if (lastTransfer != null && lastTransfer != Transfer())
        date = lastTransfer.date;
      else {
        if (element.begin!.isBefore(DateTime.now())) {
          if (!appResumed) _addTransfer(element, element.begin!);
          isUpdated = true;
        }
        date = element.begin!;
      }
      int i = 1;
      while (Jiffy(date).add(years: i).dateTime.isBefore(DateTime.now())) {
        if (!appResumed)
          _addTransfer(element, Jiffy(date).add(years: i).dateTime);
        isUpdated = true;
        i++;
      }
    }
  });
  return isUpdated;
}

void _addPosting(StandingOrder element, DateTime date) {
  Posting p = Posting(
    id: Uuid().v1(),
    title: element.title,
    description: element.description,
    account: element.account,
    amount: element.amount,
    date: date,
    postingType: element.postingType,
    category: element.category,
    accountName: element.account?.title,
    standingOrder: element,
    isStandingOrder: true,
  );

  AllData.postings.add(p);
  DBHelper.insert('Posting', p.toMap());

  //update AccountAmount
  Account ac =
      AllData.accounts.firstWhere((element) => element.id == p.account!.id);
  if (p.postingType == PostingType.income)
    AllData
        .accounts[AllData.accounts.indexWhere((element) => element.id == ac.id)]
        .bankBalance = ac.bankBalance! + p.amount!;
  else
    AllData
        .accounts[AllData.accounts.indexWhere((element) => element.id == ac.id)]
        .bankBalance = ac.bankBalance! - p.amount!;

  DBHelper.update('Account', ac.toMap(), where: "ID = '${ac.id}'");
}

void _addTransfer(StandingOrder element, DateTime date) {
  Transfer t = Transfer(
    id: Uuid().v1(),
    description: element.description,
    accountFrom: element.account,
    accountFromName: element.account!.title,
    accountTo: element.accountTo,
    accountToName: element.accountTo!.title,
    amount: element.amount,
    date: date,
    standingOrder: element,
    isStandingOrder: true,
  );

  AllData.transfers.add(t);
  DBHelper.insert('Transfer', t.toMap());

  //update AccountAmount
  Account acFrom =
      AllData.accounts.firstWhere((element) => element.id == t.accountFrom!.id);
  Account acTo =
      AllData.accounts.firstWhere((element) => element.id == t.accountTo!.id);

  AllData
      .accounts[
          AllData.accounts.indexWhere((element) => element.id == acFrom.id)]
      .bankBalance = acFrom.bankBalance! - t.amount!;
  AllData
      .accounts[AllData.accounts.indexWhere((element) => element.id == acTo.id)]
      .bankBalance = acTo.bankBalance! + t.amount!;

  DBHelper.update('Account', acFrom.toMap(), where: "ID = '${acFrom.id}'");
  DBHelper.update('Account', acTo.toMap(), where: "ID = '${acTo.id}'");
}
