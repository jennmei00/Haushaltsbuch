import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:validators/validators.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool mandatory; //check for mandatory field
  final String fieldname; //substitute for an id

  CustomTextField({
    this.labelText: '',
    this.hintText: '',
    this.keyboardType: TextInputType.text,
    this.textInputAction: TextInputAction.done,
    required this.controller,
    required this.mandatory,
    required this.fieldname,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      controller: this.controller,
      inputFormatters: this.keyboardType != TextInputType.number
          ? null
          : [
              FilteringTextInputFormatter.allow(RegExp(
                  r'^(?:-?(?:[0-9]+))?(?:\,[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?'))
            ],
      validator: (value) {
        if ((value == null || value.isEmpty) && mandatory) {
          return 'mandatory-field'.i18n();
        } else if (this.keyboardType == TextInputType.number) {
          if (!(isFloat(value!.replaceAll(',', '.')))) {
            return 'only-numbers-allowed'.i18n();
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: this.labelText,
      ),
      maxLength: this.fieldname == 'categoryName' ? 20 : null,
      maxLines: this.fieldname == 'description' ? 2 : 1,
    );
  }
}
