import 'package:flutter/material.dart';

class Category {
  String? id;
  String? title;
  String? symbol; //Datentyp???
  Color? color;

  Category({
    this.id,
    this.title,
    this.symbol,
    this.color,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Title'] = this.title;
    map['Color'] = this.color!.value.toString();
    map['Symbol'] = this.symbol;
    return map;
  }

  List<Category> listFromDB(List<Map<String, dynamic>> mapList) {
    List<Category> list = [];
    mapList.forEach((element) {
      Category category = fromDB(element);
      list.add(category);
    });
    return list;
  }

  Category fromDB(Map<String, dynamic> data) {
    // print(data['Color']);
    // int colorValue = data['Color'] != null ? int.tryParse 0;

    Category category = Category(
      id: data['ID'],
      title: data['Title'],
      color: data['Color'] == null
          ? Colors.black
          : Color(int.parse(data['Color'])),
      symbol: data['Symbol'],
    );
    return category;
  }
}
