enum PostingType {
  income,
  expense,
  transfer,
}

enum Repetition {
  weekly,
  monthly,
  quarterly,
  halfYearly,
  yearly,
}

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

enum SecurityQuestionEnum {
  Question1,
  Question2,
  Question3,
  Question4,
  Question5,
}

extension SecurityQuestionExtension on SecurityQuestionEnum {
  String get value {
    switch (this) {
      case SecurityQuestionEnum.Question1:
        return 'In welcher Stadt bzw. an welchem Ort wurdest du geboren?';
      case SecurityQuestionEnum.Question2:
        return 'Wie lautet der zweite Vorname deiner ältesten Schwester bzw. deines ältesten Bruders?';
      case SecurityQuestionEnum.Question3:
        return 'Welches war dein erstes Konzert, das du besucht hast?';
      case SecurityQuestionEnum.Question4:
        return 'Gebe Marke und Model deines Autos an.';
      case SecurityQuestionEnum.Question5:
        return 'In welcher Stadt bzw. welchem Ort haben sich deine Eltern kennengelernt?';
      default:
        return '';
    }
  }
}
