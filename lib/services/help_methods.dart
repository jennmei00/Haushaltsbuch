import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';

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
