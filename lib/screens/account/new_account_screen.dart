import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class NewAccountScreen extends StatefulWidget {
  static final routeName = '/new_account_screen';

  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  ListItem _selectedItem = ListItem('0', 'name');
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _bankBalanceController =
      TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  // Color _color = Colors.black;
  Color _iconcolor = Colors.black;
  final _formKey = GlobalKey<FormState>();
  List<ListItem> _accountTypeDropDownItems = [
    ListItem('0', 'name'),
    ListItem('1', ' ')
  ];

  void _getAccountTypeDropDownItems() {
    if (AllData.accountTypes.length != 0) {
      _accountTypeDropDownItems = [];
      // int i = 0;
      AllData.accountTypes.forEach((element) {
        _accountTypeDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
        // i++;
      });
      _selectedItem = _accountTypeDropDownItems.first;

      setState(() {});
    }
  }

  @override
  void initState() {
    _getAccountTypeDropDownItems();
    super.initState();
  }
  // ignore: todo
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
                if (_titleController.text != '' &&
                    _descriptionController.text != '' &&
                    isNumeric(_bankBalanceController.text)) {
                  Account ac = Account(
                    id: Uuid().v1(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    bankBalance: double.parse(_bankBalanceController.text),
                    color: _iconcolor,
                    accountType: AllData.accountTypes.firstWhere(
                        (element) => element.id == _selectedItem.value),
                    // symbol: ,
                  );
                  DBHelper.insert('Account', ac.toMap()).then((value) =>
                      Navigator.popAndPushNamed(
                          context, AccountScreen.routeName));
                  AllData.accounts.add(ac);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter some text in the TextFields.'),
                  ));
                }
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
                    _selectedItem = newValue as ListItem;
                    setState(() {});
                  },
                  dropdownItems: _accountTypeDropDownItems,
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
