import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

String formatDate(DateTime date) {
  initializeDateFormatting();

  var formattedDate = DateFormat.yMMMd("de").format(date);
  return '$formattedDate';
}

String formatDateMY(DateTime date) {
  initializeDateFormatting();

  var formattedDate = DateFormat.yMMMM("de").format(date);
  return '$formattedDate';
}

DateFormat weeklyDateFormat() {
  initializeDateFormatting();
  return DateFormat("'Woche vom'\n dd.MMM y", "de");
}

String formatCurrency(double amount) {
  var formattedCurrency =
      NumberFormat.currency(locale: "de", symbol: "€").format(amount);
  return '$formattedCurrency';
}

String formatRepetition(Repetition repetition) {
  if (repetition == Repetition.monthly) {
    return 'Monatlich';
  } else if (repetition == Repetition.weekly) {
    return 'Wöchentlich';
  } else if (repetition == Repetition.yearly) {
    return 'Jährlich';
  } else if (repetition == Repetition.quarterly) {
    return 'Vierteljährlich';
  } else if (repetition == Repetition.halfYearly) {
    return 'Halbjährlich';
  } else {
    return '';
  }
}

Color getAccountColorFromAccountName(String accountName) {
  Account ac =
      AllData.accounts.firstWhere((element) => element.title == accountName);
  Color accountColor = ac.color!;
  return accountColor;
}

Repetition getRepetitionFromString(String repetition) {
  if (repetition == 'Monatlich') {
    return Repetition.monthly;
  } else if (repetition == 'Wöchentlich') {
    return Repetition.weekly;
  } else if (repetition == 'Jährlich') {
    return Repetition.yearly;
  } else if (repetition == 'Vierteljährlich') {
    return Repetition.quarterly;
  } else if (repetition == 'Halbjährlich') {
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

void updateStandingOrderPostings(BuildContext context, bool appResumed) {
  AllData.postings.sort((obj, obj2) => obj.date!.compareTo(obj2.date!));
  bool isUpdated = false;

  AllData.standingOrders.forEach((element) {
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
                  : elementPosting.standingOrder?.id == element.id));
    } catch (ex) {}

    if (element.repetition == Repetition.weekly) {
      DateTime? date;
      if (lastPosting != null && lastPosting != Posting())
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
  if (appResumed && isUpdated)
    Phoenix.rebirth(context);
  else if (!appResumed && isUpdated) {
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
