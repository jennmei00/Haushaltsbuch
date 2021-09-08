import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;

  CustomTextField(
      {this.labelText: '',
      this.hintText: '',
      this.keyboardType: TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 20),
          hintText: hintText,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }
}
