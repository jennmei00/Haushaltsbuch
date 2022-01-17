import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:uuid/uuid.dart';
import 'package:haushaltsbuch/services/globals.dart';

class NewAccountScreen extends StatefulWidget {
  static final routeName = '/new_account_screen';

  final String id;

  NewAccountScreen({this.id = ''});

  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  ListItem? _selectedItem;
  TextEditingController _titleController = TextEditingController(text: '');
  TextEditingController _bankBalanceController =
      TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  Color _iconcolor = Globals.isDarkmode ? Globals.customSwatchDarkMode.keys.first : Globals.customSwatchLightMode.keys.first;
  Color _onchangedColor = Globals.isDarkmode ? Globals.customSwatchDarkMode.keys.first : Globals.customSwatchLightMode.keys.first;
  final _formKey = GlobalKey<FormState>();
  String _selectedIcon = '';

  List<ListItem> _accountTypeDropDownItems = [];

  void _getAccountTypeDropDownItems() {
    if (AllData.accountTypes.length != 0) {
      _accountTypeDropDownItems = [];
      AllData.accountTypes.forEach((element) {
        _accountTypeDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });

      setState(() {});
    }
  }

  void _getAccountData() {
    Account ac =
        AllData.accounts.firstWhere((element) => element.id == widget.id);
    // _repeatValue = Repetition.values(so.repetition!.index);
    _titleController.text = ac.title!;
    _bankBalanceController.text = ac.bankBalance!.toStringAsFixed(2);
    _descriptionController.text = ac.description!;
    _selectedItem = _accountTypeDropDownItems
        .firstWhere((element) => element.id == ac.accountType!.id);
    _iconcolor = Globals.isDarkmode ? getDarkColorFromLightColor(ac.color!) : ac.color!;
    _selectedIcon = ac.symbol!;
  }

  @override
  void initState() {
    _getAccountTypeDropDownItems();
    if (widget.id != '') {
      _getAccountData();
    } else {
      _selectedIcon = Globals.imagePathsAccountIcons[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == ''
            ? 'Neues Konto'
            : 'Konto bearbeiten'), //Text('${Globals.funktioniert}'),
        centerTitle: true,
        // backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveAccount(),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),
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
              height: 20,
            ),
            CustomTextField(
              labelText: 'Beschreibung',
              hintText: 'Kontobeschreibung',
              controller: _descriptionController,
              mandatory: false,
              fieldname: 'description',
            ),
            SizedBox(
              height: 20,
            ),
            DropDown(
              onChanged: (newValue) {
                _selectedItem = newValue as ListItem;
                setState(() {});
              },
              dropdownItems: _accountTypeDropDownItems,
              listItemValue: _selectedItem == null ? null : _selectedItem!.id,
              dropdownHintText: 'Kontoart',
            ),
            SizedBox(height: 10),
            // Divider(),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Iconfarbe',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                //Iconbutton(
                //highlightColor: Colors.transparent,
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Popup(
                          title: 'Color Picker',
                          body: ColorPickerClass(_colorChanged, _iconcolor),
                          saveButton: true,
                          cancelButton: true,
                          saveFunction: () {
                            this.setState(() {
                              _iconcolor = _onchangedColor;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      });
                    }),
                child: Icon(
                  Icons.color_lens,
                  color: _iconcolor,
                  size: MediaQuery.of(context).size.width * 0.14,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Icon',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),//BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              crossAxisCount: 4,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
              mainAxisSpacing: 20,
              children: Globals.imagePathsAccountIcons
                  .map((item) => GestureDetector(
                        onTap: () => setState(() {
                          _selectedIcon = item;
                        }),
                        child: new Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // boxShadow: [
                            //   BoxShadow(
                            //     blurRadius: _selectedIcon == item ? 5 : 5,
                            //     color: _selectedIcon == item
                            //         ? _iconcolor.withOpacity(0.2)
                            //         : _iconcolor.withOpacity(0.08),
                            //     spreadRadius: _selectedIcon == item ? 2 : 1,
                            //   )
                            // ],
                            color: _selectedIcon == item
                                ? _iconcolor.withOpacity(0.18)
                                : null,
                          ),
                          // height: MediaQuery.of(context).size.width * 0.34,
                          // width: MediaQuery.of(context).size.width * 0.34,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              child: Image.asset(
                                item,
                                color: _selectedIcon == item
                                      ? _iconcolor
                                      : Colors.grey.shade500//_iconcolor,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              // children: Globals.imagePaths
              //     .map((item) => GestureDetector(
              //           onTap: () => setState(() {
              //             _selectedIcon = item;
              //           }),
              //           child: new Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(12),
              //               border: Border.all(
              //                 width: _selectedIcon == item ? 2.1 : 1.0,
              //                 color: _selectedIcon == item
              //                     ? Theme.of(context).primaryColor
              //                     : Colors.grey.shade700,
              //               ),
              //               color: Colors.grey.shade200,
              //             ),
              //             // height: MediaQuery.of(context).size.width * 0.34,
              //             // width: MediaQuery.of(context).size.width * 0.34,
              //             child: Padding(
              //               padding: const EdgeInsets.all(5),
              //               child: CircleAvatar(
              //                   radius: MediaQuery.of(context).size.width * 0.1,
              //                   backgroundColor: _iconcolor,
              //                   child: FractionallySizedBox(
              //                     widthFactor: 0.6,
              //                     heightFactor: 0.6,
              //                     child: Image.asset(
              //                       item,
              //                       color: _iconcolor.computeLuminance() > 0.15
              //                           ? Colors.black
              //                           : Colors.white,
              //                     ),
              //                   )),
              //             ),
              //           ),
              //         ))
              //     .toList(),
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

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        Account ac = Account(
          id: widget.id != '' ? widget.id : Uuid().v1(),
          title: _titleController.text,
          description: _descriptionController.text,
          bankBalance: double.parse(_bankBalanceController.text),
          color: getColorToSave(_iconcolor),
          accountType: AllData.accountTypes
              .firstWhere((element) => element.id == _selectedItem!.id),
          symbol: _selectedIcon,
        );
        if (widget.id == '') {
          await DBHelper.insert('Account', ac.toMap());
        } else {
          await DBHelper.update('Account', ac.toMap(),
              where: "ID = '${ac.id}'");
          AllData.accounts.removeWhere((element) => element.id == ac.id);
        }

        AllData.accounts.add(ac);
        Navigator.popAndPushNamed(context, AccountScreen.routeName);
      } catch (ex) {
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
  }
}
