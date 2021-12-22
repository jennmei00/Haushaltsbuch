// import 'dart:ui';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
          style: TextStyle(
            fontFamily: 'Handwritingstyle',
            fontSize: 45,
          ),
        ),
      ),
    );
  }
}
