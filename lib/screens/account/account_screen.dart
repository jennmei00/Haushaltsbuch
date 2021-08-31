import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class AccountScreen extends StatelessWidget {
  static final routeName = '/account_screen';


  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue[200],
      child: Icon(Icons.add),
      onPressed: () {},
      ),
    appBar: AppBar(
      title: Text('Konten'),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor
    ),
    drawer: AppDrawer(),
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: FractionallySizedBox(
        widthFactor: 1,
        alignment: Alignment.center,
        child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vermögen:\n10.000€',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                
                ),
            ),
            SingleChildScrollView(
              child:
                ListView(
                  shrinkWrap: true,
                  children: [
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        title: Text('Kontokategorie 1'),
                        children: [
                          Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.lightBlue,
                            child: ListTile(
                              title: Text('Test'),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.lightBlue,
                            child: ListTile(
                              title: Text('Test 2'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
            )
          ],),
      ),
    )
  );
}
