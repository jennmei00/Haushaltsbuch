import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class Globals {

  static late List<dynamic> imagePathsCategoryIcons;
  static late List<dynamic> imagePathsAccountIcons;

  static late bool isDarkmode;

  static Color dismissibleEditColorLight = Colors.orange;
  static Color dismissibleDeleteColorLight = Colors.red.shade900;
  static Color dismissibleEditColorLDark = Colors.orange.shade300;
  static Color dismissibleDeleteColorDark = Colors.red.shade300;

  
  static final Map<ColorSwatch<Object>, String> customSwatchDarkMode =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFef9a9a)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFFba6b6c)): 'RedDark',
    ColorTools.createPrimarySwatch(const Color(0xFFf48fb1)): 'Pink',
    ColorTools.createPrimarySwatch(const Color(0xFFbf5f82)): 'PinkDark',
    ColorTools.createPrimarySwatch(const Color(0xffce93d8)): 'Purple',
    ColorTools.createPrimarySwatch(const Color(0xffb39ddb)): 'DeepPurple',
    ColorTools.createPrimarySwatch(const Color(0xff9fa8da)): 'Indigo',
    ColorTools.createPrimarySwatch(const Color(0xff90caf9)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xff81d4fa)): 'LightBlue',
    ColorTools.createPrimarySwatch(const Color(0xff80deea)): 'Cyan',
    ColorTools.createPrimarySwatch(const Color(0xff80cbc4)): 'Teal',
    ColorTools.createPrimarySwatch(const Color(0xffa5d6a7)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xffc5e1a5)): 'LightGreen',
    ColorTools.createPrimarySwatch(const Color(0xffe6ee9c)): 'Lime',
    ColorTools.createPrimarySwatch(const Color(0xfffff59d)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xffffe082)): 'Amber',
    ColorTools.createPrimarySwatch(const Color(0xffffcc80)): 'Orange',
  };

  static final Map<ColorSwatch<Object>, String> customSwatchLightMode =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFc62828)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFF8e0000)): 'RedDark',
    ColorTools.createPrimarySwatch(const Color(0xFFad1457)): 'Pink',
    ColorTools.createPrimarySwatch(const Color(0xFF78002e)): 'PinkDark',
    ColorTools.createPrimarySwatch(const Color(0xff6a1b9a)): 'Purple',
    ColorTools.createPrimarySwatch(const Color(0xff4527a0)): 'DeepPurple',
    ColorTools.createPrimarySwatch(const Color(0xff283593)): 'Indigo',
    ColorTools.createPrimarySwatch(const Color(0xff1565c0)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xff0277bd)): 'LightBlue',
    ColorTools.createPrimarySwatch(const Color(0xff00838f)): 'Cyan',
    ColorTools.createPrimarySwatch(const Color(0xff00695c)): 'Teal',
    ColorTools.createPrimarySwatch(const Color(0xff2e7d32)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xff558b2f)): 'LightGreen',
    ColorTools.createPrimarySwatch(const Color(0xff9e9d24)): 'Lime',
    ColorTools.createPrimarySwatch(const Color(0xfff9a825)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xffff8f00)): 'Amber',
    ColorTools.createPrimarySwatch(const Color(0xffef6c00)): 'Orange',
  };

}
