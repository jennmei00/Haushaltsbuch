import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';
import 'package:haushaltsbuch/services/globals.dart';

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
  Color _iconcolor = Colors.black;
  Color _onchangedColor = Colors.black;
  final _formKey = GlobalKey<FormState>();
  String _selectedIcon = '';

  List<ListItem> _accountTypeDropDownItems = [
    ListItem('0', 'name'),
    ListItem('1', ' ')
  ];

  void _getAccountTypeDropDownItems() {
    if (AllData.accountTypes.length != 0) {
      _accountTypeDropDownItems = [];
      AllData.accountTypes.forEach((element) {
        _accountTypeDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Konto'), //Text('${Globals.funktioniert}'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_titleController.text != '' &&
                    isFloat(_bankBalanceController.text)) {
                  Account ac = Account(
                    id: Uuid().v1(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    bankBalance: double.parse(_bankBalanceController.text),
                    color: _iconcolor,
                    accountType: AllData.accountTypes.firstWhere(
                        (element) => element.id == _selectedItem.id),
                    symbol: _selectedIcon,
                  );
                  DBHelper.insert('Account', ac.toMap()).then((value) =>
                      Navigator.popAndPushNamed(
                          context, AccountScreen.routeName));
                  AllData.accounts.add(ac);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Das Speichern in die Datenbank ist \n schiefgelaufen :(',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Ups, da passt etwas noch nicht :(',
                    textAlign: TextAlign.center,
                  ),
                ));
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          // body: SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   child: Form(
          //     key: _formKey,
          //     child: Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              labelText: 'Konto',
              hintText: 'Kontoname',
              controller: _titleController,
              mandatory: true,
              fieldname: 'account',
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              labelText: 'Kontostand',
              hintText: 'Aktueller Kontostand',
              controller: _bankBalanceController,
              keyboardType: TextInputType.number,
              mandatory: true,
              fieldname: 'accountBalance',
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextField(
              labelText: 'Beschreibung',
              hintText: 'Kontobeschreibung',
              controller: _descriptionController,
              mandatory: false,
              fieldname: 'description',
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
              listItemValue: _selectedItem.id,
              dropdownHintText: 'Kontoart',
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
                    ColorPickerClass(_colorChanged, _iconcolor),
                    true,
                    true,
                    () {
                      setState(() {
                        _iconcolor = _onchangedColor;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  icon: Icon(
                    Icons.color_lens,
                    color: _iconcolor,
                  ),
                ),
              ],
            ),
            Text(
              'Icon wählen: ',
              style: TextStyle(fontSize: 20),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              crossAxisCount: 4,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
              mainAxisSpacing: 20,
              children: Globals.imagePaths
                  .map((item) => GestureDetector(
                        onTap: () => setState(() {
                          _selectedIcon = item;
                        }),
                        child: new Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: _selectedIcon == item ? 2.1 : 1.0,
                              color: _selectedIcon == item
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade700,
                            ),
                            color: Colors.grey.shade200,
                          ),
                          // height: MediaQuery.of(context).size.width * 0.34,
                          // width: MediaQuery.of(context).size.width * 0.34,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.1,
                                backgroundColor: Colors.grey.shade500,
                                child: FractionallySizedBox(
                                  widthFactor: 0.6,
                                  heightFactor: 0.6,
                                  child: Image.asset(
                                    item,
                                  ),
                                )),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    print(color);
    setState(() {
      _onchangedColor = color;
    });
  }
}
