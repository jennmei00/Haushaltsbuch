import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/account_category.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:uuid/uuid.dart';

class NewAccountScreen extends StatefulWidget {
  static final routeName = '/new_account_screen';

  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  List<ListItem> _dropdownItems = [
    ListItem(1, "First Value"),
    ListItem(2, "Second Item"),
    ListItem(3, "Third Item"),
    ListItem(4, "Fourth Item")
  ];
  ListItem _selectedItem = ListItem(1, "First Value");
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _bankBalanceController =
      TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  Color _color = Colors.black;
  Color _iconcolor = Colors.black;
  final _formKey = GlobalKey<FormState>();

  //TODO: Symbol fehlt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Konto'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print(_formKey.currentState);
              if (_formKey.currentState!.validate()) {
                print('no validate');
                // Account ac = Account(
                //   id: Uuid().v1(),
                //   title: _titleController.text,
                //   description: _descriptionController.text,
                //   bankBalance: double.parse(_bankBalanceController.text),
                //   color: _color,
                //   // symbol: ,
                //   // accountCategory: ,
                // );
                // DBHelper.insert('Account', ac.toMap())
                //     .then((value) => Navigator.pop(context));
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Konto',
                  hintText: 'Kontoname',
                  controller: _titleController,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelText: 'Kontostand',
                  hintText: 'Aktueller Kontostand',
                  controller: _bankBalanceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  labelText: 'Beschreibung',
                  hintText: 'Kontobeschreibung',
                  controller: _descriptionController,
                ),
                SizedBox(
                  height: 30,
                ),
                DropDown(
                  onChanged: (newValue) {
                    // ListItem value = newValue as ListItem;
                    // print(value.value);
        
                    _selectedItem = newValue as ListItem;
                    setState(() {});
                  },
                  dropdownItems: _dropdownItems,
                  listItemValue: _selectedItem.value,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Iconfarbe auswählen: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => CustomDialog().customShowDialog(
                          context,
                          'ColorPicker',
                          ColorPickerClass(_colorChanged),
                          true,
                          true, () {
                        print('test');
                      }),
                      icon: Icon(
                        Icons.color_lens,
                        color: _iconcolor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    print(color);
    setState(() {
      _iconcolor = color;
    });
  }
}
