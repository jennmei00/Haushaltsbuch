import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:validators/validators.dart';
import 'package:community_material_icon/community_material_icon.dart';

class CustomTextField extends StatefulWidget {
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
    // this.obscureText = false,
    // this.obscureIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    if (widget.fieldname == 'oldPassword' ||
        widget.fieldname == 'userPassword' ||
        widget.fieldname == 'repeatNewPassword' ||
        widget.fieldname == 'userRepeatPassword' ||
        widget.fieldname == 'userPasswordLogin') {
      obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      keyboardType: this.widget.keyboardType == TextInputType.number
          ? TextInputType.text
          : this.widget.keyboardType,
      textInputAction: this.widget.textInputAction,
      controller: this.widget.controller,
      obscureText: obscureText,
      inputFormatters: widget.noDecimal
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^([0-9]*)?')),
            ]
          : this.widget.keyboardType == TextInputType.number
              ? [
                  FilteringTextInputFormatter.allow(RegExp(Localizations
                                  .localeOf(context)
                              .countryCode ==
                          'US'
                      ? r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?'
                      : r'^(?:-?(?:[0-9]+))?(?:\,[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?')),
                ]
              : null,
      validator: widget.validator == null
          ? (value) {
              if ((value == null || value.isEmpty) && widget.mandatory) {
                return 'mandatory-field'.i18n();
              } else if (this.widget.keyboardType == TextInputType.number) {
                if (!(isFloat(value!.replaceAll(',', '.')))) {
                  return 'only-numbers-allowed'.i18n();
                }
              } else if (widget.fieldname == 'userPassword' &&
                  value!.length < 5) {
                return 'password-validator'.i18n();
              }

              return null;
            }
          : (val) => widget.validator!(val),
      decoration: InputDecoration(
        labelText: this.widget.labelText,
        suffixIcon: widget.fieldname == 'oldPassword' ||
                widget.fieldname == 'userPassword' ||
                widget.fieldname == 'repeatNewPassword' ||
                widget.fieldname == 'userRepeatPassword' ||
                widget.fieldname == 'userPasswordLogin'
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText
                      ? CommunityMaterialIcons.eye
                      : CommunityMaterialIcons.eye_off,
                ),
              )
            : null,
      ),
      maxLength: this.widget.fieldname == 'categoryName' ? 20 : null,
      maxLines: this.widget.fieldname == 'description' ? 2 : 1,
    );
  }
}
