import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';

class NewAccountScreen extends StatefulWidget {
  static final routeName = '/new_account_screen';

  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {

  String dropdownValCategory = 'Kategorie 1';

  List<ListItem> _dropdownItems = [
    ListItem(1, "First Value"),
    ListItem(2, "Second Item"),
    ListItem(3, "Third Item"),
    ListItem(4, "Fourth Item")
  ];

   List<DropdownMenuItem<ListItem>> _dropdownMenuItems = [];
   ListItem _selectedItem = ListItem(0, '');

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value!;

  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Konto'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'Konto',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: 'Kontoname',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Kontostand',
                    labelStyle: TextStyle(fontSize: 20),
                    hintText: 'Aktueller Kontostand',
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyan,
                    border: Border.all()),
                padding: EdgeInsets.only(left: 12.0, right: 12.0),
                height: 60,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    icon: Icon(Icons.arrow_downward_rounded),
                    iconEnabledColor: Colors.black,
                    iconSize: 30,
                    value: _selectedItem,
                    items: _dropdownMenuItems,
                    // items: <String>[
                    //   'Kategorie 1',
                    //   'Kategorie 2',
                    //   'Kategorie 3',
                    //   'Kategorie 4'
                    // ].map<DropdownMenuItem<String>>((String value) {
                    //   return DropdownMenuItem<String>(
                    //     value: value,
                    //     child: Text(value),
                    //   );
                    // }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue as ListItem;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
