import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/applog.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/fileHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:localization/localization.dart';
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

  late Color _iconcolor;
  Color _onchangedColor = Globals.isDarkmode
      ? Globals.customSwatchDarkMode.keys.first
      : Globals.customSwatchLightMode.keys.first;
  final _formKey = GlobalKey<FormState>();
  String _selectedIcon = '';

  @override
  void initState() {
    if (widget.id != '') {
      Category cat =
          AllData.categories.firstWhere((element) => element.id == widget.id);
      _titleController.text = '${cat.title}';
      _iconcolor = getColor(cat.color as Color);
      _selectedIcon = cat.symbol == null ? '' : cat.symbol!;
    } else {
      _selectedIcon = Globals.imagePathsCategoryIcons[0];
      _iconcolor = Globals.isDarkmode
          ? Globals.customSwatchDarkMode.keys.first
          : Globals.customSwatchLightMode.keys.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.id == '' ? 'new-category'.i18n() : 'edit-category'.i18n()),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveCategory(),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                CustomTextField(
                  labelText: 'category-name'.i18n(),
                  hintText: '',
                  controller: _titleController,
                  mandatory: true,
                  fieldname: 'categoryName',
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'icon-color'.i18n(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Popup(
                                title: 'Color Picker',
                                body:
                                    ColorPickerClass(_colorChanged, _iconcolor),
                                saveButton: true,
                                cancelButton: true,
                                saveFunction: () {
                                  this.setState(() {
                                    _iconcolor = _onchangedColor;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            });
                          });
                    },
                    child: Icon(
                      Icons.color_lens,
                      color: _iconcolor,
                      size: MediaQuery.of(context).size.width * 0.12,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Icon',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    //TODO
                    crossAxisCount: 4, //(MediaQuery.of(context).size.width ~/ 90).toInt(),
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                    mainAxisSpacing: 20,
                    children: Globals.imagePathsCategoryIcons
                        .map((item) => GestureDetector(
                              onTap: () => setState(() {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                _selectedIcon = item;
                              }),
                              child: new Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: _selectedIcon == item
                                      ? _iconcolor.withOpacity(0.18)
                                      : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(item,
                                      color: _selectedIcon == item
                                          ? _iconcolor
                                          : Colors.grey.shade500),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
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
      try {
        if (_selectedIcon != '') {
          Category cat = Category(
            id: widget.id != '' ? widget.id : Uuid().v1(),
            title: _titleController.text,
            color: getColorToSave(_iconcolor),
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'choose-symbol'.i18n(),
              textAlign: TextAlign.center,
            ),
          ));
        }
      } catch (ex) {
      print('New Categorie Screen $ex');
        FileHelper().writeAppLog(AppLog(ex.toString(), 'Save Category'));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'snackbar-database'.i18n(),
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  }
}
