import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
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
                    onPressed: () => _selectColorFromPicker(),
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
          actionButtons: ColorPickerActionButtons(
            okButton: true,
            okIcon: Icons.save,
            closeButton: true,
            // -- glaube die Button unten gehn nicht, weil das kein dialog ist, also kein vorgefertigter von dem package
            // dialogActionButtons: false,
            // dialogActionIcons: false,
            // dialogOkButtonType: ColorPickerActionButtonType.outlined,
            // dialogCancelButtonType: ColorPickerActionButtonType.outlined,
            // dialogCancelButtonLabel: 'Cancel',
          ),
          enableOpacity: true,
          opacityTrackHeight: 14,
        ),
      ),
    );
  }

  void _colorChange(Color color) {
    print(color);
    // _iconfarbe = color;
    // setState(() {});
  }
}
