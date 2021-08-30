import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Konten'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    drawer: AppDrawer(),
  );
}