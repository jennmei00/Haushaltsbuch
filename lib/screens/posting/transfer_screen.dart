import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class TransferScreen extends StatefulWidget {
  static final routeName = '/transfer_screen';

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  DateTime _dateTime = DateTime.now();

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
            Text('Konto 1 \nDropDownbutton \nWird von Jessi noch erstellt'),
            SizedBox(height: 20),
            Icon(Icons.arrow_downward_rounded, size: 60),
            SizedBox(height: 20),
            Text('Konto 2 \nDropDownbutton \nWird von Jessi noch erstellt'),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'Betrag',
              hintText: 'in €',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            CustomTextField(
              labelText: 'BetBeschreibungrag',
              hintText: '',
            ),
          ],
        ),
      ),
    );
  }
}
