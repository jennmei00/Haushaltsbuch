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
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: AllData.categories.length == 0
          ? NothingThere(textScreen: 'Noch keine Kategorien vorhanden :(')
          : GridView.count(
              scrollDirection: Axis.vertical,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.8),
              padding: EdgeInsets.all(20),
              crossAxisCount: 3,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
              mainAxisSpacing: 12,
              children: _categoryList
                  .map(
                    (item) => //InkWell(
                      // splashColor: item.color!.withOpacity(0.2),
                      // borderRadius: BorderRadius.circular(8),
                      // onTap: () => Navigator.of(context).pushNamed(
                      //     NewCategorieScreen.routeName,
                      //     arguments: item.id),
                      Container(
                      //child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     blurRadius: 5,
                                  //     color: item.color!.withOpacity(0.1),
                                  //     spreadRadius: 2,
                                  //   )
                                  // ],
                                  color: item.color!.withOpacity(0.18),//withOpacity(0.05),
                                ),
                                // width: 60,
                                // height: 60,
                                child: InkWell(
                                  splashColor: item.color!.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => Navigator.of(context).pushNamed(
                                      NewCategorieScreen.routeName,
                                      arguments: item.id),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Image.asset(item.symbol!,
                                        color: item.color!),
                                  ),
                                ),
                              ),
                            ),
                            //SizedBox(height: 5),
                            Center(
                              // child: SingleChildScrollView( //---> Alternative zu den drei Punkten
                              //   scrollDirection: Axis.horizontal,
                              child: Text(
                                '${item.title}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: item.color),
                                textAlign: TextAlign.center,
                              ),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    //),
                  )
                  .toList(),
              // children: _categoryList
              //     .map((item) => InkWell(
              //           borderRadius: BorderRadius.circular(8),
              //           onTap: () => Navigator.of(context).pushNamed(
              //               NewCategorieScreen.routeName,
              //               arguments: item.id),
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 5.0),
              //             child: new Column(
              //               children: [
              //                 CircleAvatar(
              //                     radius:
              //                         MediaQuery.of(context).size.width * 0.1,
              //                     backgroundColor: item.color,
              //                     child: FractionallySizedBox(
              //                       widthFactor: 0.6,
              //                       heightFactor: 0.6,
              //                       child: Image.asset(
              //                         item.symbol!,
              //                         color:
              //                             item.color!.computeLuminance() > 0.2
              //                                 ? Colors.black
              //                                 : Colors.white,
              //                       ),
              //                     )),
              //                 SizedBox(height: 4),
              //                 Center(
              //                     child: Text(
              //                   '${item.title}',
              //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: item.color),
              //                   textAlign: TextAlign.center,
              //                 )),
              //               ],
              //             ),
              //           ),
              //         ))
              //     .toList(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(NewCategorieScreen.routeName, arguments: '');
        },
      ),
    );
  }
}
