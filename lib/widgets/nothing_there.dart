import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NothingThere extends StatelessWidget {
  final String textScreen;

  NothingThere({required this.textScreen});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          textScreen,
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceCodePro(fontSize: 46, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          //TextStyle(
            //fontFamily: 'Handwritingstyle',
            //fontSize: 45,
          //),
          //,
        ),
      ),
    );
  }
}
