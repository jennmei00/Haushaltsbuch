import 'package:flutter/material.dart';

class Popup extends StatefulWidget {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                // child: Stack(
                //   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     //CircleAvatar(child:Icon(Icons.ac_unit)),
                //     Positioned(
                //       height: MediaQuery.of(context).size.width * 0.1,
                //       left: -20,
                //       child: CircleAvatar(
                //         backgroundColor: Colors.lightGreen.shade400,
                //         radius: MediaQuery.of(context).size.width * 0.1,
                //         child: FractionallySizedBox(
                //           widthFactor: 0.65,
                //           heightFactor: 0.65,
                //           child: Image.asset(
                //             'assets/icons/money-bag.png',
                //           ),
                //         )),
                //     ),
                child: Text(
                  '${widget.title}',
                  style: Theme.of(context).textTheme.headline5,
                  //style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                //   ],
                // ),
              ),
              widget.body,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // if (widget.saveButton)
                    //   ElevatedButton(
                    //     onPressed: () => widget.saveFunction!(),
                    //     child: Text(
                    //       'Speichern',
                    //     ),
                    //   ),
                    // if (widget.cancelButton)
                    //   ElevatedButton(
                    //     onPressed: () => Navigator.of(context).pop(),
                    //     child: Text(
                    //       'Abbrechen',
                    //     ),
                    //   ),
                    if (widget.saveButton)
                      TextButton(
                        onPressed: () => widget.saveFunction!(),
                        child: Text(
                          'Speichern',
                        ),
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
