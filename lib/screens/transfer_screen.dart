import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  static final routeName = '/transfer_screen';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Buchen'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
  );
}