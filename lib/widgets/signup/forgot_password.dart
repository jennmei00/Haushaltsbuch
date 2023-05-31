import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';

class ForgotPasword extends StatelessWidget {
  final TextEditingController newPassword;
  final TextEditingController repeatNewPassword;
  final Function cancelPressed;
  final Function resetPressed;
  final formKey;
  const ForgotPasword({
    super.key,
    required this.newPassword,
    required this.repeatNewPassword,
    required this.cancelPressed,
    required this.resetPressed,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: newPassword,
              mandatory: true,
              fieldname: 'userPassword',
              labelText: 'new-password'.i18n(),
            ),
            SizedBox(height: 20),
            CustomTextField(
                controller: repeatNewPassword,
                mandatory: true,
                fieldname: 'userRepeatPassword',
                labelText: 'repeat-new-password'.i18n(),
                validator: (String val) {
                  if (val != newPassword.text) {
                    return 'repeat-password-validator'.i18n();
                  } else {
                    return null;
                  }
                }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => resetPressed(),
              child: Text('reset'.i18n()),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
            ),
            TextButton(
              onPressed: () => cancelPressed(),
              child: Text(
                'cancel'.i18n(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ));
  }
}
