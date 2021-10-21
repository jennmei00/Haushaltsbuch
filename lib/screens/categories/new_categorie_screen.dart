import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:uuid/uuid.dart';

class NewCategorieScreen extends StatefulWidget {
  static final routeName = '/new_categories_screen';

  @override
  State<NewCategorieScreen> createState() => _NewCategorieScreenState();
}

class _NewCategorieScreenState extends State<NewCategorieScreen> {
  TextEditingController _titleController = TextEditingController(text: '');
  Color _color = Colors.black;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Kategorie'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              Category cat = Category(
                id: Uuid().v1(),
                title: _titleController.text,
                color: _color,
              );
              DBHelper.insert('Category', cat.toMap())
                  .then((value) => Navigator.pop(context));
            },
          )
        ],
      ),
      //Kategoriename
      //Farbe Farbbabbel +
      // ignore: todo
      //TODO: Symbol Symbolbabbel
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          CustomTextField(
            labelText: 'Kategoriename',
            hintText: '',
            controller: _titleController,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Farbe wählen:'),
              // Row(
              //   children: [
              // CircleAvatar(
              //   backgroundColor: _color,
              //   radius: 10,
              // ),
              IconButton(
                onPressed: () => CustomDialog().customShowDialog(
                  context,
                  'ColorPicker',
                  ColorPickerClass(_colorChanged),true, true
                ),
                icon: Icon(Icons.color_lens),
                color: _color,
              ),
              //   ],
              // )
            ],
          ),
          // Row(
          //   children: [
          //     CircleAvatar(backgroundColor: Colors.red),
          //     CircleAvatar(backgroundColor: Colors.orange),
          //     CircleAvatar(backgroundColor: Colors.yellow),
          //     CircleAvatar(backgroundColor: Colors.green),
          //     CircleAvatar(backgroundColor: Colors.lightGreen),
          //     CircleAvatar(backgroundColor: Colors.blue),
          //     CircleAvatar(backgroundColor: Colors.lightBlue),
          //     CircleAvatar(backgroundColor: Colors.black),
          //     FloatingActionButton(
          //       onPressed: () {
          //       },
          //       child: Icon(Icons.add),
          //       mini: true,
          //     ),
          //   ],
          // ),
          SizedBox(height: 20),
          Text('Symbol'),
          Row(),
        ],
      ),
    );
  }

  void _colorChanged(Color color) {
    setState(() {
      _color = color;
    });
  }
}
