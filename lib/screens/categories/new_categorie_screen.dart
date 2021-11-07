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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Kategorie'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
            if (_formKey.currentState!.validate()) {
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
              } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Das Speichern in die Datenbank ist \n schiefgelaufen :(', textAlign: TextAlign.center,),
                  ));}
              }
              else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Ups, da passt etwas noch nicht :(', textAlign: TextAlign.center,),
                  ));
              }
            },
          )
        ],
      ),
      // ignore: todo
      //TODO: Symbol Symbolbabbel
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            CustomTextField(
              labelText: 'Kategoriename',
              hintText: '',
              controller: _titleController,
              mandatory: true,
              fieldname: 'categoryName',
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
      ),
    );
  }

  void _colorChanged(Color color) {
    setState(() {
      _color = color;
    });
  }
}
