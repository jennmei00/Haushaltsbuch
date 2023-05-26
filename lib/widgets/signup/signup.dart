import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userRepeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        //TODO: text in translator setzen
        CustomTextField(
          controller: userNameController,
          mandatory: true,
          fieldname: 'userName',
          labelText: 'Name',
        ),
        SizedBox(height: 20),
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
          labelText: 'Passwort wiederholen',
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Registrieren'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
        ),
      ],
    ));
  }
}
