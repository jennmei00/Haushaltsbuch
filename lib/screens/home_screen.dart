import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
    static final routeName = '/home_screen';

  // const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      ),
      // drawer: Drawer(),
      drawer: AppDrawer(),
      body: Container(child: Text("Das ist die Homeseite"),),
    );

    //TODO: Cupertino Design
  }
}
