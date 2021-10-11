import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class CategoriesScreen extends StatefulWidget {
  static final routeName = '/categories_screen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categoryList = [];
  bool _isLoading = true;

  Future<void> getCategoryList() async {
    _categoryList = Category().listFromDB(await DBHelper.getData('Category'));
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getCategoryList().then((value) => null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategorien'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _categoryList.length == 0
              ? Text('Keine Kategorien vorhanden, erstelle welche!')
              : GridView.count(
                  padding: EdgeInsets.all(20),
                  crossAxisCount: 4,
                  // crossAxisCount: _categoryList.length,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: _categoryList
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
