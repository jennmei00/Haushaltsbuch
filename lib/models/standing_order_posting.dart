import 'package:haushaltsbuch/models/standing_order.dart';

class StandingOrderPosting {
  String? id;
  DateTime? date;
  StandingOrder? standingOrder;

  StandingOrderPosting({
    this.id,
    this.date,
    this.standingOrder,
  });
}
