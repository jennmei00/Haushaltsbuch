import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';

class Login extends StatelessWidget {
  final TextEditingController userPasswordController;
  final Function loginPressed;
  final Function forgotPasswordPressed;
  final formKey;
  const Login(
      {super.key,
      required this.userPasswordController,
      required this.loginPressed,
      required this.forgotPasswordPressed,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
        child: Column(
      children: [
        CustomTextField(
          controller: userPasswordController,
          mandatory: false,
          fieldname: 'userPasswordLogin',
          labelText: 'password'.i18n(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => loginPressed(),
          child: Text('login'.i18n()),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
        ),
        TextButton(
          onPressed: () => forgotPasswordPressed(),
          child: Text(
            'forgot-password'.i18n(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ));
  }
}
