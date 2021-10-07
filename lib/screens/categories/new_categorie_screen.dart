import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:uuid/uuid.dart';

class NewCategorieScreen extends StatelessWidget {
  static final routeName = '/new_categories_screen';
  TextEditingController _titleController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Kategorie'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // Navigator.pop(context);
              Category cat = Category(
                id: Uuid().v1(),
                title: _titleController.text,
              );
              DBHelper.insert('Category', cat.toMap());
              // Map<String, dynamic> map = await DBHelper.getData('Category').then((value) => value.first);
              // Category cat = Category().fromDB(map);
              // print(cat.title);
            },
          )
        ],
      ),
      //Kategoriename
      //Farbe Farbbabbel +
      //Symbol Symbolbabbel
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          CustomTextField(
            labelText: 'Kategoriename',
            hintText: '',
            controller: _titleController,
          ),
          SizedBox(height: 20),
          Text('Farbe wählen:'),
          IconButton(
              onPressed: () => CustomDialog().customShowDialog(
                    context,
                    'ColorPicker',
                    ColorPickerClass(_colorChanged),
                  ),
              icon: Icon(Icons.color_lens)),
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
    print(color);
    // _iconfarbe = color;
    // setState(() {});
  }
}
