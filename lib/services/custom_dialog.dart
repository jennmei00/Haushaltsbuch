import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

class CustomDialog {
  void customShowDialog(BuildContext context, String title, Widget body) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(title, body);
        });
  }
}
