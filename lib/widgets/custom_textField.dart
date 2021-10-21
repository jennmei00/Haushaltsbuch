import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  CustomTextField({
    this.labelText: '',
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    required this.controller,
    // required this.optional,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: this.keyboardType,
        controller: this.controller,
        validator: (value) {
          print('in validator');
          print(value);
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (this.keyboardType == TextInputType.number &&
              !(isNumeric(value))) {
            return 'Only numbers allowed';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: this.labelText,
          labelStyle: TextStyle(fontSize: 20),
          //hintText: hintText,
          filled: true,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan),
          ),
          floatingLabelStyle: TextStyle(color: Colors.cyan),
          // border: OutlineInputBorder(
          //   borderSide: BorderSide(),
          //   borderRadius: BorderRadius.circular(30),
          // )),
        ));
  }
}
