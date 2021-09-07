import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/categories/new_categorie_screen.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  static final routeName = '/categories_screen';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Kategorien'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(),
        body: GridView.count(
          padding: EdgeInsets.all(20),
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.money,
                size: 50,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.savings_rounded,
                size: 50,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.card_giftcard,
                size: 50,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.cottage_sharp,
                size: 50,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.car_repair,
                size: 50,
              ),
            ),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            CircleAvatar(),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewCategorieScreen.routeName);
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      );
}
