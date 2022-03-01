import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool mandatory; //check for mandatory field
  final String fieldname; //substitute for an id
  // final FocusNode focusNode;

  CustomTextField({
    this.labelText: '',
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    this.textInputAction: TextInputAction.done,
    required this.controller,
    required this.mandatory,
    required this.fieldname,
    // this.focusNode: FocusNode(),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      // focusNode: this.focusNode,
      controller: this.controller,
      validator: (value) {
        if ((value == null || value.isEmpty) && mandatory) {
          return 'Das ist ein Pflichtfeld!';
        } else if (this.keyboardType == TextInputType.number) {
          String val = value!.replaceAll('.', '');
          val = val.replaceAll(',', '.');
          if (!(isFloat(val))) {
            return 'Nur Zahlen sind erlaubt (Punkt statt Komma)';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: this.labelText,
        //labelStyle: TextStyle(fontSize: 20),
        //hintText: hintText,
        // filled: true,
        // fillColor: Colors.grey[700]?.withOpacity(0.5),
        // focusedBorder: UnderlineInputBorder(
        //   // borderSide: BorderSide(color: Colors.cyan),
        // ),
        // floatingLabelStyle: TextStyle(color: Colors.cyan),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(),
        //   borderRadius: BorderRadius.circular(30),
        // )),
        // errorStyle: TextStyle(
        //   color: Theme.of(context).colorScheme.error,
        // ),
        // focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
        // errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
      ),
      maxLength: this.fieldname == 'categoryName' ? 20 : null,
      maxLines: this.fieldname == 'description' ? 2 : 1,
    );
  }
}
