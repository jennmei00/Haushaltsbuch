import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Iconfarbe auswählen: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () => _selectColorFromPicker(),
                    icon: Icon(Icons.color_lens),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectColorFromPicker() {
    CustomDialog().customShowDialog(
      context,
      'Color Picker',
      Container(
        child: ColorPicker(
          onColorChanged: (value) => _colorChange(value),
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.wheel: true,
          },
          heading: Text('Wähle eine Farbe'),
          subheading: Text('Wähle eine Farbschattierung'),
          wheelSubheading: Text('Schattierungen der gewählten Farbe'),
          wheelWidth: 16,
          columnSpacing: 10,
          enableOpacity: true,
          opacityTrackHeight: 14,
        ),
      ),
    );
  }

  void _colorChange(Color color) {
    print(color);
  }
}
