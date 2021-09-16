import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

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
  // Color _iconfarbe = Colors.black;

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
                height: 20,
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
                    ),
                    icon: Icon(
                      Icons.color_lens,
                      // color: _iconfarbe,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    print(color);
    // _iconfarbe = color;
    // setState(() {});
  }
}
