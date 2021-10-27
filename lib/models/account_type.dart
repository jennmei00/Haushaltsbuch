
class AccountType {
  String? id;
  String? title;

  AccountType({
    this.id,
    this.title,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['ID'] = this.id;
    map['Title'] = this.title;
    return map;
  }

  List<AccountType> listFromDB(List<Map<String, dynamic>> mapList) {
    List<AccountType> list = [];
    mapList.forEach((element) {
      AccountType accountType = fromDB(element);
      list.add(accountType);
    });
    return list;
  }

  AccountType fromDB(Map<String, dynamic> data) {
    AccountType accountType = AccountType(
      id: data['ID'],
      title: data['Title'],
    );
    return accountType;
  }
}
