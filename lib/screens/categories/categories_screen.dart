import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class CategoriesScreen extends StatefulWidget {
  static final routeName = '/categories_screen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorien'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: AllData.categires.length == 0
          ? Text('Keine Kategorien vorhanden, erstelle welche!')
          : GridView.count(
              padding: EdgeInsets.all(20),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: AllData.categires
                  .map((item) => new CircleAvatar(
                        backgroundColor: item.color,
                        child: Text('${item.title}'),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(NewCategorieScreen.routeName);
        },
      ),
    );
  }
}
