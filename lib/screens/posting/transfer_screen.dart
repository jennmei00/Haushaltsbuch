import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/models/transfer.dart';
import 'package:haushaltsbuch/screens/posting/posting_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart';

class TransferScreen extends StatefulWidget {
  static final routeName = '/transfer_screen';

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  DateTime _dateTime = DateTime.now();
  TextEditingController _amountController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  late List<ListItem> _accountDropDownItems;
  ListItem? _selectedAccountFrom;
  ListItem? _selectedAccountTo;
  final _formKey = GlobalKey<FormState>();

  void _getAccountDropDownItems() {
    _accountDropDownItems = [ListItem('', '')];
    if (AllData.accounts.length != 0) {
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      //_selectedAccountFrom = _accountDropDownItems.first;
      //_selectedAccountTo = _accountDropDownItems.first;
      setState(() {});
    } else {
      //_selectedAccountFrom = ListItem('', '');
      //_selectedAccountTo = ListItem('', '');
    }
  }

  @override
  void initState() {
    _getAccountDropDownItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umbuchung'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (isFloat(_amountController.text) &&
                    _selectedAccountFrom != _selectedAccountTo) {
                  Transfer transfer = Transfer(
                    id: Uuid().v1(),
                    description: _descriptionController.text,
                    accountFrom: AllData.accounts.firstWhere(
                        (element) => element.id == _selectedAccountFrom!.id),
                    accountTo: AllData.accounts.firstWhere(
                        (element) => element.id == _selectedAccountTo!.id),
                    amount: double.parse(_amountController.text),
                    date: _dateTime,
                    accountFromName: AllData.accounts
                        .firstWhere(
                            (element) => element.id == _selectedAccountFrom!.id)
                        .title,
                    accountToName: AllData.accounts
                        .firstWhere(
                            (element) => element.id == _selectedAccountTo!.id)
                        .title,
                  );
                  AllData.transfers.add(transfer);
                  DBHelper.insert('Transfer', transfer.toMap()).then((value) =>
                      Navigator.popAndPushNamed(
                          context, PostingScreen.routeName));
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
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Datum:'),
                Row(
                  children: [
                    Text(
                        '${_dateTime.day}. ${_dateTime.month}. ${_dateTime.year}'),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _dateTime,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        ).then((value) => setState(() => _dateTime = value!));
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            DropDown(
              dropdownItems: _accountDropDownItems,
              listItemValue: _selectedAccountFrom == null ? null : _selectedAccountFrom!.id,
              onChanged: (newValue) {
                _selectedAccountFrom = newValue as ListItem;
                setState(() {});
              },
              dropdownHintText: 'Von Konto',
            ),
            SizedBox(height: 20),
            Icon(Icons.arrow_downward_rounded, size: 60),
            SizedBox(height: 20),
            DropDown(
              dropdownItems: _accountDropDownItems,
              listItemValue: _selectedAccountTo == null ? null : _selectedAccountTo!.id,
              onChanged: (newValue) {
                _selectedAccountTo = newValue as ListItem;
                setState(() {});
              },
              dropdownHintText: 'Zu Konto',
            ),
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
          ],
        ),
      ),
    );
  }
}
