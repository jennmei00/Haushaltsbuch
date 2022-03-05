import 'package:flutter/material.dart';

class Popup extends StatefulWidget {
  final String? title;
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
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.title != '')
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                  child: Text(
                    '${widget.title}',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              widget.body,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.saveButton)
                      TextButton(
                        onPressed: () => widget.saveFunction!(),
                        child: Text(
                          'Speichern',
                        ),
                      ),
                    if (widget.saveButton && widget.cancelButton)
                      SizedBox(
                        width: 5,
                      ),
                    if (widget.cancelButton)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Abbrechen',
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
