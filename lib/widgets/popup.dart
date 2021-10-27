import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String title;
  final Widget body;
  final bool saveButton;
  final bool cancelButton;
  final Function? saveFunction;

  const Popup({
    this.title: '',
    this.body: const Text(''),
    this.saveButton = true,
    this.cancelButton = true,
    this.saveFunction,
  });

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
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
                child: Text(
                  '$title',
                  style: Theme.of(context).textTheme.headline4,
                  // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              body,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (saveButton)
                      TextButton(
                        onPressed: () => saveFunction!(),
                        child: Text(
                          'Speichern',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    if (cancelButton)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Abbrechen',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                  ],
                ),
              )
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
