import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';

// ignore: must_be_immutable
class DropDown extends StatelessWidget {
  final List<ListItem> dropdownItems;
  final int listItemValue;
  final Function onChanged;

  DropDown(
      {required this.dropdownItems,
      this.listItemValue = 999,
      required this.onChanged});

  ListItem _selectedItem = ListItem(999, '');

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems = [];

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
    _dropdownMenuItems = buildDropDownMenuItems(dropdownItems);
    if (listItemValue == 999)
      _selectedItem = _dropdownMenuItems[0].value!;
    else
      _selectedItem =
          dropdownItems.firstWhere((element) => element.value == listItemValue);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          //color: Colors.cyan,
          border: Border.all()),
      padding: EdgeInsets.only(left: 12.0, right: 12.0),
      height: 60,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600],
          ),
          icon: Icon(Icons.arrow_drop_down_circle_outlined),
          iconEnabledColor: Colors.grey[600],
          iconSize: 30,
          value: _selectedItem,
          items: _dropdownMenuItems,
          onChanged: (newValue) => onChanged(newValue),
        ),
      ),
    );
  }

  int getDropDownValue() {
    return this._selectedItem.value;
  }
}