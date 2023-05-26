import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userRepeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        //TODO: text in translator setzen
        CustomTextField(
          controller: userPasswordController,
          mandatory: true,
          fieldname: 'userPassword',
          labelText: 'Passwort',
        ),
        SizedBox(height: 20),
        CustomTextField(
          controller: userRepeatPasswordController,
          mandatory: true,
          fieldname: 'userRepeatPassword',
          labelText: 'Passwort',
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Zurücksetzen'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Abbrechen',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ));
  }
}
