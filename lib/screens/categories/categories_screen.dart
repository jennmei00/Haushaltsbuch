import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';

class CategoriesScreen extends StatefulWidget {
  static final routeName = '/categories_screen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Category> _categoryList = AllData.categories;

  @override
  void initState() {
    _categoryList.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorien'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: AllData.categories.length == 0
          ? NothingThere(
              textScreen:
                  'Noch keine Kategorien vorhanden :(') //Text('Keine Kategorien vorhanden, erstelle welche!')
          : GridView.count(
              padding: EdgeInsets.all(20),
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: _categoryList
                  .map((item) => GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            NewCategorieScreen.routeName,
                            arguments: item.id),
                        child: new CircleAvatar(
                          backgroundColor: item.color,
                          child: Text('${item.title}'),
                        ),
                      ))
                  .toList(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(NewCategorieScreen.routeName, arguments: '');
        },
      ),
    );
  }
}
