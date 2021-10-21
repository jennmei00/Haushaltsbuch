
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = '/home_screen';

  // void _openDatabase() {
  //   // DBHelper.deleteDatabse();
  //   DBHelper.openDatabase();
  // }

  // void _openDirectory() async {
  //   await getApplicationDocumentsDirectory();
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   print(dir);
  // }

  @override
  Widget build(BuildContext context) {
    // _openDatabase();

    // _openDirectory();

    final _formKey = GlobalKey<FormState>();



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('alles in ordnung');
              }
            },
            icon: Icon(Icons.save),
          )
        ],
      ),

      // drawer: Drawer(),
      drawer: AppDrawer(),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(

                validator: (val) {
                  print(val);
                  if (val == '') return 'Textfeld darf nicht null sein';

                  return null;
                },
              ),
              TextFormField(
                validator: (val) {
                  print(val);
                  if (val == '') return 'Textfeld darf nicht nullllllll sein';

                  return null;
                },
              )
            ],
          )
          // Container(
          //   child: Text("Das ist die Homeseite"),
          // ),
          ),
    );

    // ignore: todo
    //TODO: Cupertino Design
  }
}
