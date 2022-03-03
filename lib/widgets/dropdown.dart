import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';

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
      this.dropdownHintText = 'Bitte auswählen'});

  // ListItem _selectedItem = ListItem('999', '');

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
    // if (listItemValue == '999')
    //   _selectedItem = _dropdownMenuItems[0].value!;
    // else
    //   _selectedItem =
    //       dropdownItems.firstWhere((element) => element.id == listItemValue);

    return //Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(3),
        //     // color: Colors.cyan,
        //     // color: Colors.grey[700]?.withOpacity(0.5),
        //     color: Colors.grey[300]?.withOpacity(0.5),
        //     // border: Border.all()
        //   ),
        //   padding: EdgeInsets.only(left: 12.0, right: 12.0),
        //height: 60,
        //child: DropdownButtonHideUnderline(
        DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        //itemHeight: 20,
        hint: Text(dropdownHintText),
        validator: (value) {
          //ListItem item = value as ListItem;
          //print(item.name);
          //if (item.name == '') {
          if (value == null) {return 'Das ist ein Pflichtfeld';}
          else {return null;}

          //}
        },
        // style: TextStyle(
        //   fontSize: 20,
        //   // color: Colors.grey[400],
        //   color: Colors.grey[700],
        // ),
        icon: Icon(Icons.arrow_drop_down),
        iconEnabledColor: Colors.grey[600],
        iconSize: 30,
        value: listItemValue == null
            ? null
            : dropdownItems
                .firstWhere((element) => element.id == listItemValue),
        items: _dropdownMenuItems,
        onChanged: (newValue) => onChanged(newValue),
        // decoration: InputDecoration(
        //   //labelStyle: TextStyle(fontSize: 20),
        //   filled: true,
        //   errorStyle: TextStyle(
        //     color: Theme.of(context).colorScheme.error,
        //   ),
        //   focusedErrorBorder: UnderlineInputBorder(
        //       borderSide:
        //           BorderSide(color: Theme.of(context).colorScheme.error)),
        //   errorBorder: UnderlineInputBorder(
        //       borderSide:
        //           BorderSide(color: Theme.of(context).colorScheme.error)),
        // ),
      ),
      //  ),
      //),
    );
  }

  // int getDropDownValue() {
  //   return this._selectedItem.value;
  // }
}
