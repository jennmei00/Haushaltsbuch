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
  final bool noDecimal;
  final Function? validator;
  final bool enabled;

  CustomTextField({
    this.labelText = '',
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    required this.controller,
    required this.mandatory,
    required this.fieldname,
    this.noDecimal = false,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      keyboardType: this.keyboardType == TextInputType.number
          ? TextInputType.text
          : this.keyboardType,
      textInputAction: this.textInputAction,
      controller: this.controller,
      inputFormatters: noDecimal
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^([0-9]*)?')),
            ]
          : this.keyboardType == TextInputType.number
              // ? this.keyboardType.decimal == true
              ? [
                  FilteringTextInputFormatter.allow(RegExp(Localizations
                                  .localeOf(context)
                              .countryCode ==
                          'US'
                      ? r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?'
                      : r'^(?:-?(?:[0-9]+))?(?:\,[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?')),
                ]
              : null,
      validator: validator == null
          ? (value) {
              if ((value == null || value.isEmpty) && mandatory) {
                return 'mandatory-field'.i18n();
              } else if (this.keyboardType == TextInputType.number) {
                if (!(isFloat(value!.replaceAll(',', '.')))) {
                  return 'only-numbers-allowed'.i18n();
                }
              } else if (fieldname == 'userPassword' && value!.length < 5) {
                return 'password-validator'.i18n();
              }

              return null;
            }
          : (val) => validator!(val),
      decoration: InputDecoration(
        labelText: this.labelText,
      ),
      maxLength: this.fieldname == 'categoryName' ? 20 : null,
      maxLines: this.fieldname == 'description' ? 2 : 1,
    );
  }
}
