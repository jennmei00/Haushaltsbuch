import 'package:flutter/material.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';

class SecurityQuestion extends StatefulWidget {
  const SecurityQuestion({super.key});

  @override
  State<SecurityQuestion> createState() => _SecurityQuestionState();
}

class _SecurityQuestionState extends State<SecurityQuestion> {
  TextEditingController userSecurityAnswer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        //TODO: text in translator setzen
        // DropdownButton<String>(
        //   items: [
        //     DropdownMenuItem(child: Text('FRAGE 1')),
        //     DropdownMenuItem(child: Text('FRAGE 2'))
        //   ],
        //   onChanged: (val) {},
        //   value: 'FRAGE 1',
        // ),
        SizedBox(height: 20),
        CustomTextField(
          controller: userSecurityAnswer,
          mandatory: true,
          fieldname: 'userSecurityAnswer',
          labelText: 'Antwort',
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Antworten'),
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
