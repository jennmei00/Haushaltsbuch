class AccountCategory {
  String? id;
  String? title;

  AccountCategory({
    this.id,
    this.title,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Title'] = this.title;
    return map;
  }

  List<AccountCategory> listFromDB(List<Map<String, dynamic>> mapList) {
    List<AccountCategory> list = [];
    mapList.forEach((element) {
      AccountCategory accountCategory = fromDB(element);
      list.add(accountCategory);
    });
    return list;
  }

  AccountCategory fromDB(Map<String, dynamic> data) {
    AccountCategory accountCategory = AccountCategory(
      id: data['ID'],
      title: data['Title'],
    );
    return accountCategory;
  }
}
