import 'package:flutter/material.dart';

class Imprint extends StatelessWidget {
  const Imprint({Key? key}) : super(key: key);
  static final routeName = '/imprint_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
        centerTitle: true,
      ),
      body: Container(

      ),
    );
  }
}
