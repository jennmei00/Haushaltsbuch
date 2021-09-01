import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String title;
  final Widget body;

  Popup(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.7,
        widthFactor: 0.8,
        child: Column(children: [
          Text('$title'),
          body,
        ]),
      ),
    );
  }
}
