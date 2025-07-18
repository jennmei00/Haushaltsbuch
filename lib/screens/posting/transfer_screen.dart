import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:localization/localization.dart';
import 'package:uuid/uuid.dart';

class TransferScreen extends StatefulWidget {
  static final routeName = '/transfer_screen';
  final String id;

  TransferScreen({this.id = ''});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  DateTime _dateTime = DateTime.now();
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  List<ListItem> _accountDropDownItems = [];
  ListItem? _selectedAccountFrom;
  ListItem? _selectedAccountTo;
  final _formKey = GlobalKey<FormState>();
  Account? _oldAccountFrom;
  Account? _oldAccountTo;
  double? _oldAmount;
  StandingOrder? _transferSO;
  bool _transferIsSO = false;

  void _getAccountDropDownItems() {
    if (AllData.accounts.length != 0) {
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
    }
  }

  void _getTransfersData() {
    Transfer transfer =
        AllData.transfers.firstWhere((element) => element.id == widget.id);

    if (transfer.accountFrom != null)
      _selectedAccountFrom = _accountDropDownItems
          .firstWhere((element) => element.id == transfer.accountFrom!.id);
    if (transfer.accountTo != null)
      _selectedAccountTo = _accountDropDownItems
          .firstWhere((element) => element.id == transfer.accountTo!.id);

    if (transfer.standingOrder != null) _transferSO = transfer.standingOrder!;
    if (transfer.isStandingOrder != null)
      _transferIsSO = transfer.isStandingOrder!;

    _dateTime = transfer.date!;
    _amountController.text = formatTextFieldCurrency(transfer.amount!);
    _descriptionController.text = '${transfer.description}';

    _oldAccountFrom = transfer.accountFrom;
    _oldAccountTo = transfer.accountTo;
    _oldAmount = transfer.amount;
  }

  @override
  void didChangeDependencies() {
    if (widget.id != '') {
    Transfer transfer =
        AllData.transfers.firstWhere((element) => element.id == widget.id);
      _amountController.text = formatTextFieldCurrency(transfer.amount!,
          locale: Localizations.localeOf(this.context).languageCode);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _getAccountDropDownItems();

    if (widget.id != '') {
      _getTransfersData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('transfer'.i18n()),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveTransfer(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            children: [
              SizedBox(height: 20),
              DropDown(
                dropdownItems: _accountDropDownItems,
                listItemValue: _selectedAccountFrom == null
                    ? null
                    : _selectedAccountFrom!.id,
                onChanged: (newValue) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectedAccountFrom = newValue as ListItem;
                  setState(() {});
                },
                dropdownHintText: 'from-account'.i18n(),
              ),
              _selectedAccountFrom == null && widget.id != ''
                  ? Text(
                      'actual-account-deleted'.i18n(),
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              Container(
                height: 65,
                child: Image.asset(
                  'assets/icons/other_icons/arrow.png',
                  color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 20),
              DropDown(
                dropdownItems: _accountDropDownItems,
                listItemValue:
                    _selectedAccountTo == null ? null : _selectedAccountTo!.id,
                onChanged: (newValue) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectedAccountTo = newValue as ListItem;
                  setState(() {});
                },
                dropdownHintText: 'to-account'.i18n(),
              ),
              _selectedAccountTo == null && widget.id != ''
                  ? Text(
                      'actual-account-deleted'.i18n(),
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'amount'.i18n(),
                    hintText: 'in €',
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    mandatory: true,
                    fieldname: 'amount',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: SimpleCalculator(
                                value: _amountController.text == ''
                                    ? 0
                                    : double.tryParse(_amountController.text
                                        .replaceAll(',', '.'))!,
                                onChanged: (key, value, expression) {
                                  if (key == '=') {
                                    _amountController.text =
                                        formatTextFieldCurrency(value!,
                                            locale: Localizations.localeOf(
                                                    this.context)
                                                .languageCode);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.calculate),
                  iconSize: 40,
                ),
              ]),
              SizedBox(height: 20),
              CustomTextField(
                labelText: 'description'.i18n(),
                hintText: '',
                controller: _descriptionController,
                mandatory: false,
                fieldname: 'description',
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("${'date'.i18n()}:"),
                  Row(
                    children: [
                      GestureDetector(
                        child: Text(formatDate(_dateTime, context)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDatePicker(
                            context: context,
                            initialDate: _dateTime,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 365)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          ).then(
                            (value) {
                              if (value != null)
                                setState(() => _dateTime = value);
                            },
                          );
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            showDatePicker(
                              context: context,
                              initialDate: _dateTime,
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then(
                              (value) {
                                if (value != null)
                                  setState(() => _dateTime = value);
                              },
                            );
                          }),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransfer() async {
    String stringAmount = _amountController.text.replaceAll('.', '');
    stringAmount = stringAmount.replaceAll(',', '.');
    if (_formKey.currentState!.validate() &&
        _selectedAccountFrom != _selectedAccountTo) {
      try {
        Transfer transfer = Transfer(
          id: widget.id != '' ? widget.id : Uuid().v1(),
          description: _descriptionController.text,
          accountFrom: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountFrom!.id),
          accountTo: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountTo!.id),
          amount: double.parse(stringAmount),
          date: _dateTime,
          accountFromName: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountFrom!.id)
              .title,
          accountToName: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountTo!.id)
              .title,
          standingOrder: _transferSO,
          isStandingOrder: _transferIsSO,
        );

        if (widget.id == '') {
          //add function
          DBHelper.insert('Transfer', transfer.toMap());
        } else {
          //edit function
          await DBHelper.update('Transfer', transfer.toMap(),
              where: "ID = '${transfer.id}'");
          AllData.transfers.removeWhere((element) => element.id == transfer.id);

          if (_oldAccountFrom != null) {
            AllData.accounts
                .removeWhere((element) => element.id == _oldAccountFrom!.id);
            _oldAccountFrom!.bankBalance =
                _oldAccountFrom!.bankBalance! + _oldAmount!;
            await DBHelper.update('Account', _oldAccountFrom!.toMap(),
                where: "ID = '${_oldAccountFrom!.id}'");
          }
          if (_oldAccountTo != null) {
            AllData.accounts
                .removeWhere((element) => element.id == _oldAccountTo!.id);
            _oldAccountTo!.bankBalance =
                _oldAccountTo!.bankBalance! - _oldAmount!;
            AllData.accounts.addAll([_oldAccountFrom!, _oldAccountTo!]);
            await DBHelper.update('Account', _oldAccountTo!.toMap(),
                where: "ID = '${_oldAccountTo!.id}'");
          }
        }

        Account acFrom = AllData.accounts
            .firstWhere((element) => element.id == transfer.accountFrom!.id);
        Account acTo = AllData.accounts
            .firstWhere((element) => element.id == transfer.accountTo!.id);
        AllData.accounts.removeWhere((element) => element.id == acFrom.id);
        AllData.accounts.removeWhere((element) => element.id == acTo.id);
        acFrom.bankBalance = acFrom.bankBalance! - transfer.amount!;
        acTo.bankBalance = acTo.bankBalance! + transfer.amount!;
        AllData.accounts.addAll([acTo, acFrom]);
        await DBHelper.update('Account', acFrom.toMap(),
            where: "ID = '${acFrom.id}'");
        await DBHelper.update('Account', acTo.toMap(),
            where: "ID = '${acTo.id}'");

        AllData.transfers.add(transfer);

        if (widget.id == '')
          Navigator.pop(context);
        else
          Navigator.of(context).pop(true);
      } catch (ex) {
      print('Transfer Screen $ex');
        FileHelper().writeAppLog(AppLog(ex.toString(), 'Save Transfer'));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'snackbar-database'.i18n(),
            textAlign: TextAlign.center,
          ),
        ));
      }
    } else {
      if (_selectedAccountFrom == _selectedAccountTo &&
          _selectedAccountTo != null &&
          _selectedAccountFrom != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'different-accounts'.i18n(),
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'snackbar-textfield'.i18n(),
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  }
}
