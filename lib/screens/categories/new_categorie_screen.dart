import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/models/posting.dart';
import 'package:haushaltsbuch/models/standing_order.dart';
import 'package:haushaltsbuch/screens/categories/categories_screen.dart';
import 'package:haushaltsbuch/services/DBHelper.dart';
import 'package:haushaltsbuch/services/globals.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:haushaltsbuch/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      _iconcolor = cat.color as Color;
      _selectedIcon = cat.symbol == null ? '' : cat.symbol!;
    } else {
      _selectedIcon = Globals.imagePathsCategoryIcons[0];
      _iconcolor = Globals.isDarkmode
          ? Globals.customSwatchDarkMode.keys.first
          : Globals.customSwatchLightMode.keys.first;
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
        // backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveCategory(),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            //physics: NeverScrollableScrollPhysics(),//BouncingScrollPhysics(),
            //padding: const EdgeInsets.all(10.0),
            children: [
              SizedBox(height: 10),
              CustomTextField(
                labelText: 'Kategoriename',
                hintText: '',
                controller: _titleController,
                mandatory: true,
                fieldname: 'categoryName',
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Iconfarbe',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  //Iconbutton(
                  //highlightColor: Colors.transparent,
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Popup(
                            title: 'Color Picker',
                            body: ColorPickerClass(_colorChanged, _iconcolor),
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
                      }),
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
                  physics:
                      BouncingScrollPhysics(), //NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 4,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                  mainAxisSpacing: 20,
                  children: Globals.imagePathsCategoryIcons
                      .map((item) => GestureDetector(
                            onTap: () => setState(() {
                              _selectedIcon = item;
                            }),
                            child: new Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // boxShadow: [
                                //   BoxShadow(
                                //     blurRadius: _selectedIcon == item ? 5 : 5,
                                //     color: _selectedIcon == item
                                //         ? _iconcolor.withOpacity(0.2)
                                //         : Theme.of(context)
                                //             .colorScheme
                                //             .onSurface
                                //             .withOpacity(0.08),
                                //     spreadRadius: _selectedIcon == item ? 2 : 1,
                                //   )
                                // ],
                                color: _selectedIcon == item
                                    ? _iconcolor.withOpacity(0.18)
                                    : null,
                              ),
                              // height: MediaQuery.of(context).size.width * 0.34,
                              // width: MediaQuery.of(context).size.width * 0.34,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(item,
                                    color: _selectedIcon == item
                                        ? _iconcolor
                                        : Colors.grey
                                            .shade500 //Theme.of(context).colorScheme.onSurface,
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
              ),
              SizedBox(height: 20),
              // widget.id == '' || widget.id == 'default'
              //     ? SizedBox()
              //     : ElevatedButton(
              //         style: ButtonStyle(
              //           alignment: Alignment.centerLeft,
              //           // textStyle: TextStyle(),
              //           padding: MaterialStateProperty.all(EdgeInsets.only(left: 10, right: 10)),
              //           backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
              //         ),
              //         onPressed: () {
              //           AllData.postings.forEach((element) async {
              //             Posting newPosting = element;
              //             newPosting.category = AllData.categories
              //                 .firstWhere((element) => element.id == 'default');
              //             await DBHelper.update('Posting', newPosting.toMap(),
              //                 where: "ID = '${element.id}'");
              //             AllData.postings[AllData.postings.indexWhere(
              //                     (posting) => posting.id == element.id)] =
              //                 newPosting;
              //           });
              //           AllData.standingOrders.forEach((element) async {
              //             StandingOrder newSO = element;
              //             newSO.category = AllData.categories
              //                 .firstWhere((element) => element.id == 'default');
              //             await DBHelper.update('StandingOrder', newSO.toMap(),
              //                 where: "ID = '${element.id}'");
              //             AllData.standingOrders[AllData.standingOrders
              //                 .indexWhere((so) => so.id == element.id)] = newSO;
              //           });

              //           AllData.categories
              //               .removeWhere((element) => element.id == widget.id);
              //           DBHelper.delete('Category', where: "ID = '${widget.id}'");

              //           ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(content: Text('Kategorie wurde gelöscht')));

              //           Navigator.of(context)
              //             ..pop()
              //             ..popAndPushNamed(CategoriesScreen.routeName);
              //         },
              //         child: Text(
              //           'Kategorie löschen',
              //           style: TextStyle(color: Theme.of(context).colorScheme.onError),
              //         )),
              //         SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _colorChanged(Color color) {
    setState(() {
      _onchangedColor = color;
    });
    print(_onchangedColor);
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
      } catch (ex) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Das Speichern in die Datenbank ist \n schiefgelaufen :(',
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  }
}
