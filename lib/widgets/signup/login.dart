import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userPasswordController = TextEditingController();

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
        ElevatedButton(
          onPressed: () {},
          child: Text('Anmelden'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Passwort vergessen',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ));
  }
}
