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
  // late List<ListItem> _accountFromDropDownItems;
  late List<ListItem> _accountDropDownItems;
  late ListItem _selectedAccountFrom;
  late ListItem _selectedAccountTo;

  void _getAccountDropDownItems() {
    if (AllData.accounts.length != 0) {
      _accountDropDownItems = [];
      AllData.accounts.forEach((element) {
        _accountDropDownItems
            .add(ListItem(element.id.toString(), element.title.toString()));
      });
      _selectedAccountFrom = _accountDropDownItems.first;
      _selectedAccountTo = _accountDropDownItems.first;
      setState(() {});
    } else {
      _selectedAccountFrom = ListItem('', '');
      _selectedAccountTo = ListItem('', '');
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
        actions: [
          IconButton(
            onPressed: () {
              if (_descriptionController.text != '' &&
                  isNumeric(_amountController.text))
              //Different accounts???
              {
                Transfer transfer = Transfer(
                  id: Uuid().v1(),
                  description: _descriptionController.text,
                  accountFrom: AllData.accounts.firstWhere(
                      (element) => element.id == _selectedAccountFrom.value),
                  accountTo: AllData.accounts.firstWhere(
                      (element) => element.id == _selectedAccountTo.value),
                  amount: double.parse(_amountController.text),
                  date: _dateTime,
                );
                AllData.transfers.add(transfer);
                DBHelper.insert('Transfer', transfer.toMap()).then((value) =>
                    Navigator.popAndPushNamed(
                        context, PostingScreen.routeName));
              } else
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter some text in the TextFields.'),
                ));
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                listItemValue: _selectedAccountFrom.value,
                onChanged: (newValue) {
                  _selectedAccountFrom = newValue as ListItem;
                  setState(() {});
                }),
            SizedBox(height: 20),
            Icon(Icons.arrow_downward_rounded, size: 60),
            SizedBox(height: 20),
            DropDown(
                dropdownItems: _accountDropDownItems,
                listItemValue: _selectedAccountTo.value,
                onChanged: (newValue) {
                  _selectedAccountTo = newValue as ListItem;
                  setState(() {});
                }),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Betrag',
              hintText: 'in €',
              keyboardType: TextInputType.number,
              controller: _amountController,
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Beschreibung',
              hintText: '',
              controller: _descriptionController,
            ),
          ],
        ),
      ),
    );
  }
}
