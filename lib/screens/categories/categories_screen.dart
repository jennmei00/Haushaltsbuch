import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:haushaltsbuch/widgets/nothing_there.dart';
import 'package:localization/localization.dart';

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
    int test = (MediaQuery.of(context).size.width ~/ 25).toInt();
    print(test);
    return Scaffold(
      appBar: AppBar(
        title: Text('categories'.i18n()),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        selectedMenuItem: 'categories',
      ),
      body: AllData.categories.length == 0
          ? NothingThere(textScreen: 'no-categories'.i18n())
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    childAspectRatio: 0.8,
                    padding: EdgeInsets.all(20),
                    //TODO:
                    crossAxisCount:
                        3, //(MediaQuery.of(context).size.width ~/ 120).toInt(),
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                    mainAxisSpacing: 12,
                    children: _categoryList
                        .map(
                          (item) => Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: getColor(item.color!)
                                            .withOpacity(0.18),
                                        border: Border.all(
                                            color: getColor(item.color!),
                                            width: 0.5)),
                                    child: InkWell(
                                      splashColor: getColor(item.color!)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(
                                              NewCategorieScreen.routeName,
                                              arguments: item.id),
                                      onLongPress: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("delete-category".i18n()),
                                            content: Text(
                                                "delete-category-text".i18n()),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    if (item.id == 'default') {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'couldnt-delete-category'
                                                                      .i18n())));
                                                      Navigator.of(context)
                                                          .pop();
                                                      return;
                                                    }

                                                    AllData.postings.forEach(
                                                        (element) async {
                                                      if (element
                                                              .category!.id ==
                                                          item.id) {
                                                        Posting newPosting =
                                                            element;
                                                        newPosting.category = AllData
                                                            .categories
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    'default');
                                                        await DBHelper.update(
                                                            'Posting',
                                                            newPosting.toMap(),
                                                            where:
                                                                "ID = '${element.id}'");
                                                        AllData.postings[AllData
                                                                .postings
                                                                .indexWhere(
                                                                    (posting) =>
                                                                        posting
                                                                            .id ==
                                                                        element
                                                                            .id)] =
                                                            newPosting;
                                                      }
                                                    });
                                                    AllData.standingOrders
                                                        .forEach(
                                                            (element) async {
                                                      if (element.category !=
                                                          null) {
                                                        if (element
                                                                .category!.id ==
                                                            item.id) {
                                                          StandingOrder newSO =
                                                              element;
                                                          newSO.category = AllData
                                                              .categories
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      'default');
                                                          await DBHelper.update(
                                                              'StandingOrder',
                                                              newSO.toMap(),
                                                              where:
                                                                  "ID = '${element.id}'");
                                                          AllData.standingOrders[AllData
                                                              .standingOrders
                                                              .indexWhere((so) =>
                                                                  so.id ==
                                                                  element
                                                                      .id)] = newSO;
                                                        }
                                                      }
                                                    });
                                                    AllData.categories
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                item.id);
                                                    DBHelper.delete('Category',
                                                        where:
                                                            "ID = '${item.id}'");

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                'deleted-category'
                                                                    .i18n())));

                                                    Navigator.of(context)
                                                      ..pop()
                                                      ..popAndPushNamed(
                                                          CategoriesScreen
                                                              .routeName);
                                                  },
                                                  child: Text("delete".i18n())),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text("cancel".i18n()),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Image.asset(item.symbol!,
                                            color: getColor(item.color!)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${item.title}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: getColor(item.color!)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(NewCategorieScreen.routeName, arguments: '');
        },
      ),
    );
  }
}
