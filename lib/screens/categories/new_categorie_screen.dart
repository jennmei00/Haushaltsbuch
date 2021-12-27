import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/widgets/custom_dialog.dart';
import 'package:haushaltsbuch/services/globals.dart';
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
  String _selectedIcon = '';

  @override
  void initState() {
    if (widget.id != '') {
      Category cat =
          AllData.categories.firstWhere((element) => element.id == widget.id);
      _titleController.text = '${cat.title}';
      _iconcolor = cat.color as Color;
      _selectedIcon = cat.symbol == null ? '' : cat.symbol!;
    }
    // _getImageList();
    // print(imagePaths);
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
                Text(
                  'Iconfarbe auswählen: ',
                  style: TextStyle(fontSize: 20),
                ),
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
            Text(
              'Icon wählen: ',
              style: TextStyle(fontSize: 20),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              crossAxisCount: 4,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
              mainAxisSpacing: 20,
              children: Globals.imagePaths
                  .map((item) => GestureDetector(
                        onTap: () => setState(() {
                          _selectedIcon = item;
                          print(_selectedIcon);
                        }),
                        child: new Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: _selectedIcon == item ? 5 : 5,
                                color: _selectedIcon == item
                                    ? _iconcolor.withOpacity(0.2)
                                    : _iconcolor.withOpacity(0.08),
                                spreadRadius: _selectedIcon == item ? 2 : 1,
                              )
                            ],
                            color: _selectedIcon == item
                                ? _iconcolor.withOpacity(0.12)
                                : null,
                          ),
                          // height: MediaQuery.of(context).size.width * 0.34,
                          // width: MediaQuery.of(context).size.width * 0.34,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              child: Image.asset(item, color: _iconcolor),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              // children: Globals.imagePaths
              //     .map((item) => GestureDetector(
              //           onTap: () => setState(() {
              //             _selectedIcon = item;
              //           }),
              //           child: new Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(12),
              //               border: Border.all(
              //                 width: _selectedIcon == item ? 2.1 : 1.0,
              //                 color: _selectedIcon == item
              //                     ? Theme.of(context).primaryColor
              //                     : Colors.grey.shade700,
              //               ),
              //               color: Colors.grey.shade200,
              //             ),
              //             // height: MediaQuery.of(context).size.width * 0.34,
              //             // width: MediaQuery.of(context).size.width * 0.34,
              //             child: Padding(
              //               padding: const EdgeInsets.all(5),
              //               child: CircleAvatar(
              //                   radius: MediaQuery.of(context).size.width * 0.1,
              //                   backgroundColor: _iconcolor,
              //                   child: FractionallySizedBox(
              //                     widthFactor: 0.6,
              //                     heightFactor: 0.6,
              //                     child: Image.asset(
              //                       item,
              //                       color: _iconcolor.computeLuminance() > 0.15
              //                           ? Colors.black
              //                           : Colors.white,
              //                     ),
              //                   )),
              //             ),
              //           ),
              //         ))
              //     .toList(),
            ),
            Row(),
            SizedBox(height: 20),
            widget.id == ''
                ? SizedBox()
                : TextButton(
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      // textStyle: TextStyle(),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      AllData.categories
                          .removeWhere((element) => element.id == widget.id);
                      DBHelper.delete('Category', where: "ID = '${widget.id}'");

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kategorie wurde gelöscht')));

                      Navigator.of(context)
                        ..pop()
                        ..popAndPushNamed(CategoriesScreen.routeName);
                    },
                    child: Text(
                      'Kategorie löschen',
                      style: TextStyle(color: Colors.red),
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
      if (_selectedIcon != '') {
        Category cat = Category(
          id: widget.id != '' ? widget.id : Uuid().v1(),
          title: _titleController.text,
          color: _iconcolor,
          symbol: _selectedIcon,
        );

        if (widget.id == '') {
          await DBHelper.insert('Category', cat.toMap());
        } else {
          await DBHelper.update('Category', cat.toMap(),
              where: "ID = '${cat.id}'");
          AllData.categories.removeWhere((element) => element.id == cat.id);
        }

        AllData.categories.add(cat);
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
            'Bitte wähle noch ein Symbol aus :)',
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  }
}
