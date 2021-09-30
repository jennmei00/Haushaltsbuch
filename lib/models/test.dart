class Test {
  String tabelle1GUID;
  String variable1;
  int variable2;

  Test(this.tabelle1GUID, this.variable1, this.variable2);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['Tabelle1GUID'] = tabelle1GUID;
    map['variable1'] = variable1;
    map['variable2'] = variable2;
    return map;
  }

  // @override
  // String toString() {
  //   return 'Memo{id: $id, titel: $title, untertitel: $subtitle, memotext: $memotext}';
  // }
}
