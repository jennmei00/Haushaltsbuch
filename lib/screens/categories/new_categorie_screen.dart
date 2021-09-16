import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/custom_dialog.dart';
import 'package:haushaltsbuch/widgets/color_picker.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class NewCategorieScreen extends StatelessWidget {
  static final routeName = '/new_categories_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Kategorie'),
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
