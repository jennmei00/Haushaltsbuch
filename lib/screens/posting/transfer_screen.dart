import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

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

  void _getAccountDropDownItems() {
    if (AllData.accounts.length != 0) {
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
    }
  }

  void _getPostingsData() {
    Transfer transfer =
        AllData.transfers.firstWhere((element) => element.id == widget.id);

    if (transfer.accountFrom != null)
      _selectedAccountFrom = _accountDropDownItems
          .firstWhere((element) => element.id == transfer.accountFrom!.id);
    if (transfer.accountTo != null)
      _selectedAccountTo = _accountDropDownItems
          .firstWhere((element) => element.id == transfer.accountTo!.id);

    _dateTime = transfer.date!;
    _amountController.text = '${transfer.amount!.toStringAsFixed(2)}';
    _descriptionController.text = '${transfer.description}';

    _oldAccountFrom = transfer.accountFrom;
    _oldAccountTo = transfer.accountTo;
    _oldAmount = transfer.amount;
  }

  @override
  void initState() {
    _getAccountDropDownItems();

    if (widget.id != '') {
      _getPostingsData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umbuchung'),
        // backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveTransfer(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Datum:'),
            //     Row(
            //       children: [
            //         Text(
            //           '${DateFormat.yMMMd().format(_dateTime)}'),
            //             //'${_dateTime.day}. ${_dateTime.month}. ${_dateTime.year}'),
            //         IconButton(
            //           icon: Icon(Icons.date_range),
            //           onPressed: () {
            //             showDatePicker(
            //               context: context,
            //               initialDate: _dateTime,
            //               firstDate:
            //                   DateTime.now().subtract(Duration(days: 365)),
            //               lastDate: DateTime.now().add(Duration(days: 365)),
            //             ).then((value) {
            //               if (value != null) setState(() => _dateTime = value);
            //             });
            //           },
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            DropDown(
              dropdownItems: _accountDropDownItems,
              listItemValue: _selectedAccountFrom == null
                  ? null
                  : _selectedAccountFrom!.id,
              onChanged: (newValue) {
                _selectedAccountFrom = newValue as ListItem;
                setState(() {});
              },
              dropdownHintText: 'Von Konto',
            ),
            _selectedAccountFrom == null && widget.id != ''
                ? Text(
                    'Das eigentliche Konto wurde gelöscht',
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            Container(
              height: 65,
              //width: 65,
              child: Image.asset(
                'assets/icons/other_icons/arrow.png',
                color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.8),
              ),
            ),//Icon(Icons.arrow_downward_rounded, size: 60),
            SizedBox(height: 20),
            DropDown(
              dropdownItems: _accountDropDownItems,
              listItemValue:
                  _selectedAccountTo == null ? null : _selectedAccountTo!.id,
              onChanged: (newValue) {
                _selectedAccountTo = newValue as ListItem;
                setState(() {});
              },
              dropdownHintText: 'Zu Konto',
            ),
            _selectedAccountTo == null && widget.id != ''
                ? Text(
                    'Das eigentliche Konto wurde gelöscht',
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Betrag',
              hintText: 'in €',
              keyboardType: TextInputType.number,
              controller: _amountController,
              mandatory: true,
              fieldname: 'amount',
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Beschreibung',
              hintText: '',
              controller: _descriptionController,
              mandatory: false,
              fieldname: 'description',
            ),
            SizedBox(height: 20,),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Datum:'),
                Row(
                  children: [
                    Text(formatDate(_dateTime)),
                    IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
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
    );
  }

  void _saveTransfer() async {
    // if (_selectedAccountFrom == _selectedAccountTo) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //         'Die Konton müssen unterschiedlich sein :O',
    //         textAlign: TextAlign.center,
    //       ),
    //     ));
    // }
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
          amount: double.parse(_amountController.text),
          date: _dateTime,
          accountFromName: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountFrom!.id)
              .title,
          accountToName: AllData.accounts
              .firstWhere((element) => element.id == _selectedAccountTo!.id)
              .title,
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
        Navigator.pop(context);
      } catch (ex) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Das Speichern in die Datenbank ist \n schiefgelaufen :(',
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
            'Die Konton müssen unterschiedlich sein :O',
            textAlign: TextAlign.center,
          ),
        ));
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
}
