import 'package:flutter/material.dart';

class ExpansionTileFormField extends FormField<bool> {
  ExpansionTileFormField(
      {Widget? title,
      Widget? subtitle,
      FormFieldValidator<bool>? validator,
      List<Widget>? children})
      : super(
            validator: validator,
            builder: (FormFieldState<bool> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: title!,
                    subtitle: subtitle,
                    children: children!,
                  ),
                  state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${state.errorText}',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              );
            });
}
