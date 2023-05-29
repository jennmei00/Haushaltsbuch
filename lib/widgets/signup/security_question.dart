import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/enums.dart';
import 'package:haushaltsbuch/widgets/custom_textField.dart';
import 'package:localization/localization.dart';

class SecurityQuestion extends StatelessWidget {
  final TextEditingController userSecurityAnswer;
  final int userSecurityQuestionIdx;
  final Function questionChanged;
  final Function answerPressed;
  final formKey;

  const SecurityQuestion({
    super.key,
    required this.userSecurityAnswer,
    required this.userSecurityQuestionIdx,
    required this.questionChanged,
    required this.answerPressed,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
        child: Column(
      children: [
        DropdownButton<int>(
          value: userSecurityQuestionIdx,
          underline: Container(),
          isExpanded: true,
          items: SecurityQuestionEnum.values
              .map((e) => DropdownMenuItem(
                  value: e.index,
                  child: Text(
                    e.value,
                    overflow: TextOverflow.visible,
                  )))
              .toList(),
          onChanged: (val) => questionChanged(val),
        ),
        SizedBox(height: 20),
        CustomTextField(
          controller: userSecurityAnswer,
          mandatory: true,
          fieldname: 'userSecurityAnswer',
          labelText: 'answer'.i18n(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => answerPressed(),
          child: Text('answer-button'.i18n()),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'cancel'.i18n(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ));
  }
}
