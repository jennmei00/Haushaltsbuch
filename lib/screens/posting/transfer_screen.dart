import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/dropdown_classes.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/dropdown.dart';

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

  void _getAccountDropDownItems() {
    if (AllData.accounts.length != 0) {
      _accountDropDownItems = [];
      AllData.accounts.forEach((element) {
        _accountDropDownItems.add(ListItem(1, element.title.toString()));
      });
      setState(() {});
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
              Navigator.of(context).pop();
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
            DropDown(dropdownItems: _accountDropDownItems, onChanged: () {}),
            SizedBox(height: 20),
            Icon(Icons.arrow_downward_rounded, size: 60),
            SizedBox(height: 20),
            DropDown(dropdownItems: _accountDropDownItems, onChanged: () {}),
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
