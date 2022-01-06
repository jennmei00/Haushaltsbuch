import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/theme.dart';

class InputTheme {

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );
  }

  InputDecorationTheme theme(colorScheme) => InputDecorationTheme(
    contentPadding: EdgeInsets.all(18),
    isDense: false,
    // labelStyle: TextStyle(
    //   fontSize: 18,
    // ),
    enabledBorder: _buildBorder(Colors.grey[600]!),
    focusedBorder: _buildBorder(colorScheme.primary),
    errorBorder: _buildBorder(colorScheme.error),
    focusedErrorBorder: _buildBorder(colorScheme.error),
    disabledBorder: _buildBorder(Colors.grey[300]!),
    errorStyle: TextStyle(
      color: colorScheme.error,
    ),
  );
}
