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

  final String id;

  NewCategorieScreen({this.id = ''});

  @override
  State<NewCategorieScreen> createState() => _NewCategorieScreenState();
}

class _NewCategorieScreenState extends State<NewCategorieScreen> {
  TextEditingController _titleController = TextEditingController(text: '');

  Color _iconcolor = Colors.black;
  Color _onchangedColor = Colors.black;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.id != '') {
      Category cat =
          AllData.categires.firstWhere((element) => element.id == widget.id);
      _titleController.text = '${cat.title}';
      _iconcolor = cat.color as Color;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.id == '' ? 'Neue Kategorie' : 'Kategorie bearbeiten'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveCategory(),
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
                  onPressed: () => CustomDialog().customShowDialog(
                    context,
                    'ColorPicker',
                    ColorPickerClass(_colorChanged, _iconcolor),
                    true,
                    true,
                    () {
                      setState(() {
                        _iconcolor = _onchangedColor;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  icon: Icon(
                    Icons.color_lens,
                    color: _iconcolor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Symbol'),
            Row(),
            SizedBox(height: 20),
            widget.id == ''
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      AllData.categires
                          .removeWhere((element) => element.id == widget.id);
                      DBHelper.delete('Category', where: "ID = '${widget.id}'");

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kategorie wurde gelöscht')));

                      Navigator.of(context)
                        ..pop()
                        ..popAndPushNamed(CategoriesScreen.routeName);
                    },
                    child: Text(
                      'Kategorie Löschen',
                      style: TextStyle(color: Colors.red),
                      // textAlign: TextAlign.left,
                    )),
          ],
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    setState(() {
      _onchangedColor = color;
    });
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      // if (_titleController.text != '') {
      Category cat = Category(
        id: widget.id != '' ? widget.id : Uuid().v1(),
        title: _titleController.text,
        color: _iconcolor,
      );

      if (widget.id == '') {
        await DBHelper.insert('Category', cat.toMap());
      } else {
        await DBHelper.update('Category', cat.toMap(),
            where: "ID = '${cat.id}'");
        AllData.categires.removeWhere((element) => element.id == cat.id);
      }

      AllData.categires.add(cat);
      Navigator.of(context)
        ..pop()
        ..popAndPushNamed(CategoriesScreen.routeName);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       'Das Speichern in die Datenbank ist \n schiefgelaufen :(',
      //       textAlign: TextAlign.center,
      //     ),
      //   ));
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ups, da passt etwas noch nicht :(',
          textAlign: TextAlign.center,
        ),
      ));
    }
    ;
  }
}
