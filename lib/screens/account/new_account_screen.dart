import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/screens/account/account_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
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
  Color _iconcolor = Globals.isDarkmode
      ? Globals.customSwatchDarkMode.keys.first
      : Globals.customSwatchLightMode.keys.first;
  Color _onchangedColor = Globals.isDarkmode
      ? Globals.customSwatchDarkMode.keys.first
      : Globals.customSwatchLightMode.keys.first;
  final _formKey = GlobalKey<FormState>();
  String _selectedIcon = '';
  DateTime _creationDate = DateTime.now();
  double _initialBankBalance = 0;

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
    // print(Localizations.localeOf(context));
    //??????? Fehler
    Account ac =
        AllData.accounts.firstWhere((element) => element.id == widget.id);
    _creationDate = ac.creationDate!;
    _initialBankBalance = ac.initialBankBalance!;
    _titleController.text = ac.title!;
    _bankBalanceController.text =
    formatTextFieldCurrency(ac.bankBalance!);
        // NumberFormat("##0.00", "de").format(ac.bankBalance!);
    _descriptionController.text = ac.description!;
    _selectedItem = _accountTypeDropDownItems
        .firstWhere((element) => element.id == ac.accountType!.id);
    _iconcolor =
        Globals.isDarkmode ? getDarkColorFromLightColor(ac.color!) : ac.color!;
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
        title: Text(widget.id == '' ? 'new-account'.i18n() : 'edit-account'.i18n()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveAccount(),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                labelText: 'account'.i18n(),
                hintText: 'account-name'.i18n(),
                controller: _titleController,
                mandatory: true,
                fieldname: 'account',
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                  labelText: 'bank-balance'.i18n(),
                  hintText: 'current-bank-balance'.i18n(),
                  controller: _bankBalanceController,
                  keyboardType: TextInputType.number,
                  mandatory: true,
                  fieldname: 'accountBalance',
                  textInputAction: TextInputAction.next),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                labelText: 'description'.i18n(),
                hintText: 'account-description'.i18n(),
                controller: _descriptionController,
                mandatory: false,
                fieldname: 'description',
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(
                height: 20,
              ),
              DropDown(
                onChanged: (newValue) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectedItem = newValue as ListItem;
                  setState(() {});
                },
                dropdownItems: _accountTypeDropDownItems,
                listItemValue: _selectedItem == null ? null : _selectedItem!.id,
                dropdownHintText: 'account-type'.i18n(),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'icon-color'.i18n(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    showDialog(
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
                        });
                  },
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
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                crossAxisCount: 4,
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                mainAxisSpacing: 20,
                children: Globals.imagePathsAccountIcons
                    .map((item) => GestureDetector(
                          onTap: () => setState(() {
                            _selectedIcon = item;
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }),
                          child: new Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _selectedIcon == item
                                  ? _iconcolor.withOpacity(0.18)
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                child: Image.asset(item,
                                    color: _selectedIcon == item
                                        ? _iconcolor
                                        : Colors.grey.shade500),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    setState(() {
      _onchangedColor = color;
    });
  }

  void _saveAccount() async {
    String stringBankBalance = _bankBalanceController.text.replaceAll('.', '');
    stringBankBalance = stringBankBalance.replaceAll(',', '.');
    if (_formKey.currentState!.validate()) {
      final timeDifferenceToCreation =
          DateTime.now().difference(_creationDate).inHours;
      if (widget.id != '' &&
          AllData.accounts
                  .where((element) => element.id == widget.id)
                  .first
                  .bankBalance !=
              double.parse(stringBankBalance) &&
          timeDifferenceToCreation > 1) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title:  Text("bank-balance-cahnge".i18n()),
                  content:  Text(
                      "bank-balance-change-text".i18n()),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          _saveToDatabase();
                          Navigator.of(context).pop(false);
                        },
                        child:  Text("yes".i18n())),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child:  Text("cancel".i18n())),
                  ]);
            });
      }
      _saveToDatabase();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'snackbar-textfield'.i18n(),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void _saveToDatabase() async {
    String stringBankBalance = _bankBalanceController.text.replaceAll('.', '');
    stringBankBalance = stringBankBalance.replaceAll(',', '.');
    try {
      if (widget.id == '') {
        _initialBankBalance = double.parse(stringBankBalance);
        _creationDate = DateTime.now();
      }

      Account ac = Account(
        id: widget.id != '' ? widget.id : Uuid().v1(),
        title: _titleController.text,
        description: _descriptionController.text,
        bankBalance: double.parse(stringBankBalance),
        creationDate: _creationDate,
        initialBankBalance: _initialBankBalance,
        color: getColorToSave(_iconcolor),
        accountType: AllData.accountTypes
            .firstWhere((element) => element.id == _selectedItem!.id),
        symbol: _selectedIcon,
      );
      if (widget.id == '') {
        await DBHelper.insert('Account', ac.toMap());
      } else {
        await DBHelper.update('Account', ac.toMap(), where: "ID = '${ac.id}'");
        AllData.accounts.removeWhere((element) => element.id == ac.id);
      }

      AllData.accounts.add(ac);
      //Add Account to Accountvisibility.txt
      FileHelper().writeMapAppend({ac.id!: true});
      Globals.accountVisibility.addAll({ac.id!: true});

      Navigator.popAndPushNamed(context, AccountScreen.routeName);
    } catch (ex) {
      print(ex);
      FileHelper().writeAppLog(AppLog(ex.toString(), 'Save Account'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'snackbar-database'.i18n(),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
