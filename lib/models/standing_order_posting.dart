import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';

class StandingOrderPosting {
  String? id;
  DateTime? date;
  StandingOrder? standingOrder;

  StandingOrderPosting({
    this.id,
    this.date,
    this.standingOrder,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Date'] = this.date!.toIso8601String();
    map['StandingOrderID'] = this.standingOrder!.id;
    return map;
  }

  List<StandingOrderPosting> listFromDB(List<Map<String, dynamic>> mapList) {
    List<StandingOrderPosting> list = [];
    mapList.forEach((element) async {
      StandingOrderPosting standingOrderPosting = await fromDB(element);
      list.add(standingOrderPosting);
    });
    return list;
  }

  Future<StandingOrderPosting> fromDB(Map<String, dynamic> data) async {
    StandingOrderPosting standingOrderPosting = StandingOrderPosting(
      id: data['ID'],
      date: DateTime.parse(data['Date']),
      standingOrder: await StandingOrder().fromDB(await DBHelper.getOneData(
          'StandingOrder',
          where: "ID = '${data['StandingOrderID']}'")),
    );
    return standingOrderPosting;
  }
}
