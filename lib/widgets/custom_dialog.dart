import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/popup.dart';

class CustomDialog {
  void customShowDialog(BuildContext context, String title, Widget body,
      bool savebutton, bool cancelbutton,
      [Function? savefunction]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Popup(
                title: title,
                body: body,
                saveButton: savebutton,
                cancelButton: cancelbutton,
                saveFunction: savefunction);
          });
        });
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Popup(
    //         title: title,
    //         body: body,
    //         saveButton: savebutton,
    //         cancelButton: cancelbutton,
    //         saveFunction: savefunction);
    //   },
    // );
  }
}

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(builder: (context, setState) {
    //         return Popup(
    //             title: title,
    //             body: body,
    //             saveButton: savebutton,
    //             cancelButton: cancelbutton,
    //             saveFunction: savefunction);
    //       });
    //     });