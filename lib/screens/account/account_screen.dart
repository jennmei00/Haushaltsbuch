import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class AccountScreen extends StatelessWidget {
  static final routeName = '/account_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Konten'),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor
    ),
    drawer: AppDrawer(),
  );
}
