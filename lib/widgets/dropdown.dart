import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:localization/localization.dart';

// ignore: must_be_immutable
class DropDown extends StatelessWidget {
  final List<ListItem> dropdownItems;
  final String? listItemValue;
  final Function onChanged;
  final String dropdownHintText;

  DropDown(
      {required this.dropdownItems,
      this.listItemValue,
      required this.onChanged,
      required this.dropdownHintText});

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

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        hint: Text(dropdownHintText),
        validator: (value) {
          if (value == null) {
            return 'mandatory-field'.i18n();
          } else {
            return null;
          }
        },
        icon: Icon(Icons.arrow_drop_down),
        iconEnabledColor: Colors.grey[600],
        iconSize: 30,
        value: listItemValue == null
            ? null
            : dropdownItems
                .firstWhere((element) => element.id == listItemValue),
        items: _dropdownMenuItems,
        onChanged: (newValue) => onChanged(newValue),
      ),
    );
  }
}
