import 'package:haushaltsbuch/models/enums.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  var formattedDate = DateFormat.yMMMd().format(date);
  return '$formattedDate';
}

String formatCurrency(double amount) {
  var formattedCurrency = NumberFormat.currency(locale: "de", symbol: "€").format(amount);
  return '$formattedCurrency';
}

String formatRepetition(Repetition repetition) {
  if (repetition == Repetition.monthly) {
    return 'Monatlich';
  }
  else if (repetition == Repetition.weekly) {
    return 'Wöchentlich';
  }
  else if (repetition == Repetition.yearly) {
    return 'Jährlich';
  }
  else if (repetition == Repetition.weekly) {
    return 'Täglich';
  }
  else {
    return '';
  }
}

Repetition getRepetitionFromString(String repetition) {
  if (repetition == 'Monatlich') {
    return Repetition.monthly;
  }
  else if (repetition == 'Wöchentlich') {
    return Repetition.weekly;
  }
  else if (repetition == 'Jährlich') {
    return Repetition.yearly;
  }
  else if (repetition == 'Täglich') {
    return Repetition.daily;
  }
  else {
    return Repetition.daily;
  }
}