import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
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
              if (_titleController.text != '') {
                Category cat = Category(
                  id: Uuid().v1(),
                  title: _titleController.text,
                  color: _color,
                );
                DBHelper.insert('Category', cat.toMap()).then((value) =>
                    Navigator.popAndPushNamed(
                        context,
                        CategoriesScreen
                            .routeName));
                AllData.categires.add(cat);
              } else
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter some text in the TextFields.'),
                ));
            },
          )
        ],
      ),
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
              IconButton(
                onPressed: () => CustomDialog().customShowDialog(context,
                    'ColorPicker', ColorPickerClass(_colorChanged), true, true),
                icon: Icon(Icons.color_lens),
                color: _color,
              ),
            ],
          ),
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
