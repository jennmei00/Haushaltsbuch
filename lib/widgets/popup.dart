import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String title;
  final Widget body;

  Popup({this.title: '', this.body: const Text('')});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('$title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              body,
            ],
          ),
        )
        // FractionallySizedBox(
        //   heightFactor: 0.7,
        //   widthFactor: 0.8,
        //   child: Column(children: [
        //     Text('$title'),
        //     body,
        //   ]),
        // ),
        );
  }
}
