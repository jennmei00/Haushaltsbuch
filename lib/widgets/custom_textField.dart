import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool mandatory; //check for mandatory field
  final String fieldname; //substitute for an id

  CustomTextField({
    this.labelText: '',
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    required this.controller,
    required this.mandatory,
    required this.fieldname,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      controller: this.controller,
      validator: (value) {
        if ((value == null || value.isEmpty) && mandatory) {
          return 'Das ist ein Pflichtfeld!';
        } else if (this.keyboardType == TextInputType.number &&
            !(isFloat(value!))) {
          return 'Nur Zahlen sind erlaubt (Punkt statt Komma)';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: this.labelText,
        labelStyle: TextStyle(fontSize: 20),
        //hintText: hintText,
        filled: true,
        // fillColor: Colors.grey[700]?.withOpacity(0.5),
        // focusedBorder: UnderlineInputBorder(
        //   // borderSide: BorderSide(color: Colors.cyan),
        // ),
        // floatingLabelStyle: TextStyle(color: Colors.cyan),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(),
        //   borderRadius: BorderRadius.circular(30),
        // )),
      ),
      maxLength: this.fieldname == 'categoryName' ? 20 : null,
    );
  }
}
