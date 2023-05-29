import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';

class Signup extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController userPasswordController;
  final TextEditingController userRepeatPasswordController;
  final formKey;

  final Function registerPressed;

  const Signup(
      {super.key,
      required this.userNameController,
      required this.userPasswordController,
      required this.userRepeatPasswordController,
      this.formKey,
      required this.registerPressed});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: userNameController,
              mandatory: true,
              fieldname: 'userName',
              labelText: 'name'.i18n(),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: userPasswordController,
              mandatory: true,
              fieldname: 'userPassword',
              labelText: 'password'.i18n(),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: userRepeatPasswordController,
              mandatory: true,
              validator: (String val) {
                if (val != userPasswordController.text) {
                  return 'repeat-password-validator'.i18n();
                } else {
                  return null;
                }
              },
              fieldname: 'userRepeatPassword',
              labelText: 'repeat-password'.i18n(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => registerPressed(),
              child: Text('register'.i18n()),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Abbrechen',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ));
  }
}
