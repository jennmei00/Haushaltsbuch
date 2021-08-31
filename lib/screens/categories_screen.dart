import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  static final routeName = '/categories_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Kategorien'),
      centerTitle: true,
      backgroundColor: Colors.green,
    ),
    drawer: AppDrawer(),
  );
}