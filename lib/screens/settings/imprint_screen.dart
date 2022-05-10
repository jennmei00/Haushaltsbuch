import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Imprint extends StatelessWidget {
  const Imprint({Key? key}) : super(key: key);
  static final routeName = '/imprint_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('imprint'.i18n()),
        centerTitle: true,
      ),
      body: Container(

      ),
    );
  }
}
