import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class Globals {
  static late List<dynamic> imagePathsCategoryIcons;
  static late List<dynamic> imagePathsAccountIcons;
  static late Map<String, bool> accountVisibility;


  static late String appName;
  static late String packageName;
  static late String version;
  static late String buildNumber;

  static late bool isDarkmode;

  static Color dismissibleEditColorLight = Colors.orange;
  static Color dismissibleDeleteColorLight = Colors.red.shade900;
  static Color dismissibleEditColorLDark = Color.fromARGB(255, 197, 149, 76);
  static Color dismissibleDeleteColorDark = Colors.red.shade300;

  static final Map<ColorSwatch<Object>, String> customSwatchDarkMode =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFe57373)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFFf06292)): 'Pink',
    ColorTools.createPrimarySwatch(const Color(0xffba68c8)): 'Purple',
    ColorTools.createPrimarySwatch(const Color(0xff9575cd)): 'DeepPurple',
    ColorTools.createPrimarySwatch(const Color(0xff7986cb)): 'Indigo',
    ColorTools.createPrimarySwatch(const Color(0xff64b5f6)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xff4fc3f7)): 'LightBlue',
    ColorTools.createPrimarySwatch(const Color(0xff4dd0e1)): 'Cyan',
    ColorTools.createPrimarySwatch(const Color(0xff4db6ac)): 'Teal',
    ColorTools.createPrimarySwatch(const Color(0xff81c784)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xffaed581)): 'LightGreen',
    ColorTools.createPrimarySwatch(const Color(0xffdce775)): 'Lime',
    ColorTools.createPrimarySwatch(const Color(0xfffff176)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xffffd54f)): 'Amber',
    ColorTools.createPrimarySwatch(const Color(0xffffb74d)): 'Orange',
    ColorTools.createPrimarySwatch(const Color(0xffff8a65)): 'DeepOrange',
    ColorTools.createPrimarySwatch(const Color(0xffa1887f)): 'Brown',
    ColorTools.createPrimarySwatch(const Color(0xffe0e0e0)): 'Grey',
    ColorTools.createPrimarySwatch(const Color(0xff90a4ae)): 'BlueGrey',
  };

  static final Map<ColorSwatch<Object>, String> customSwatchLightMode =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFc62828)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFFad1457)): 'Pink',
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
    ColorTools.createPrimarySwatch(const Color(0xffe64a19)): 'DeepOrange',
    ColorTools.createPrimarySwatch(const Color(0xff5d4037)): 'Brown',
    ColorTools.createPrimarySwatch(const Color(0xff616161)): 'Grey',
    ColorTools.createPrimarySwatch(const Color(0xff455a64)): 'BlueGrey',
  };

  static final Map<ColorSwatch<Object>, String> customSwatchDarkMode2 =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFef9a9a)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFFba6b6c)): 'RedDark',
    ColorTools.createPrimarySwatch(const Color(0xFFf48fb1)): 'Pink',
    ColorTools.createPrimarySwatch(const Color(0xFFbf5f82)): 'PinkDark',
    ColorTools.createPrimarySwatch(const Color(0xffce93d8)): 'Purple',
    ColorTools.createPrimarySwatch(const Color(0xff9c64a6)): 'PurpleDark',
    ColorTools.createPrimarySwatch(const Color(0xffb39ddb)): 'DeepPurple',
    ColorTools.createPrimarySwatch(const Color(0xff836fa9)): 'DeepPurpleDark',
    ColorTools.createPrimarySwatch(const Color(0xff9fa8da)): 'Indigo',
    ColorTools.createPrimarySwatch(const Color(0xff6f79a8)): 'IndigoDark',
    ColorTools.createPrimarySwatch(const Color(0xff90caf9)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xff5d99c6)): 'BlueDark',
    ColorTools.createPrimarySwatch(const Color(0xff81d4fa)): 'LightBlue',
    ColorTools.createPrimarySwatch(const Color(0xff4ba3c7)): 'LightBlueDark',
    ColorTools.createPrimarySwatch(const Color(0xff80deea)): 'Cyan',
    ColorTools.createPrimarySwatch(const Color(0xff4bacb8)): 'CyanDark',
    ColorTools.createPrimarySwatch(const Color(0xff80cbc4)): 'Teal',
    ColorTools.createPrimarySwatch(const Color(0xff4f9a94)): 'TealDark',
    ColorTools.createPrimarySwatch(const Color(0xffa5d6a7)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xff75a478)): 'GreenDark',
    ColorTools.createPrimarySwatch(const Color(0xffa5d6a7)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xffc5e1a5)): 'LightGreen',
    ColorTools.createPrimarySwatch(const Color(0xff94af76)): 'LightGreenDark',
    ColorTools.createPrimarySwatch(const Color(0xffe6ee9c)): 'Lime',
    ColorTools.createPrimarySwatch(const Color(0xffb3bc6d)): 'LimeDark',
    ColorTools.createPrimarySwatch(const Color(0xfffff59d)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xffcbc26d)): 'YellowDark',
    ColorTools.createPrimarySwatch(const Color(0xffffe082)): 'Amber',
    ColorTools.createPrimarySwatch(const Color(0xffcaae53)): 'AmberDark',
    ColorTools.createPrimarySwatch(const Color(0xffffcc80)): 'Orange',
    ColorTools.createPrimarySwatch(const Color(0xffca9b52)): 'OrangeDark',
    ColorTools.createPrimarySwatch(const Color(0xffffab91)): 'DeepOrange',
    ColorTools.createPrimarySwatch(const Color(0xffc97b63)): 'DeepOrangeDark',
    ColorTools.createPrimarySwatch(const Color(0xffbcaaa4)): 'Brown',
    ColorTools.createPrimarySwatch(const Color(0xff8c7b75)): 'BrownDark',
    ColorTools.createPrimarySwatch(const Color(0xffeeeeee)): 'Grey',
    ColorTools.createPrimarySwatch(const Color(0xffbcbcbc)): 'GreyDark',
    ColorTools.createPrimarySwatch(const Color(0xffb0bec5)): 'BlueGrey',
    ColorTools.createPrimarySwatch(const Color(0xff808e95)): 'BlueGreyDark',
  };

  static final Map<ColorSwatch<Object>, String> customSwatchLightMode2 =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xFFc62828)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xFF8e0000)): 'RedDark',
    ColorTools.createPrimarySwatch(const Color(0xFFad1457)): 'Pink',
    ColorTools.createPrimarySwatch(const Color(0xFF78002e)): 'PinkDark',
    ColorTools.createPrimarySwatch(const Color(0xff6a1b9a)): 'Purple',
    ColorTools.createPrimarySwatch(const Color(0xff4a0072)): 'PurpleDark',
    ColorTools.createPrimarySwatch(const Color(0xff4527a0)): 'DeepPurple',
    ColorTools.createPrimarySwatch(const Color(0xff140078)): 'DeepPurpleDark',
    ColorTools.createPrimarySwatch(const Color(0xff283593)): 'Indigo',
    ColorTools.createPrimarySwatch(const Color(0xff001970)): 'IndigoDark',
    ColorTools.createPrimarySwatch(const Color(0xff1565c0)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xff004ba0)): 'BlueDark',
    ColorTools.createPrimarySwatch(const Color(0xff0277bd)): 'LightBlue',
    ColorTools.createPrimarySwatch(const Color(0xff005b9f)): 'LightBlueDark',
    ColorTools.createPrimarySwatch(const Color(0xff00838f)): 'Cyan',
    ColorTools.createPrimarySwatch(const Color(0xff006978)): 'CyanDark',
    ColorTools.createPrimarySwatch(const Color(0xff00695c)): 'Teal',
    ColorTools.createPrimarySwatch(const Color(0xff004c40)): 'TealDark',
    ColorTools.createPrimarySwatch(const Color(0xff2e7d32)): 'Green',
    ColorTools.createPrimarySwatch(const Color(0xff00600f)): 'GreenDark',
    ColorTools.createPrimarySwatch(const Color(0xff558b2f)): 'LightGreen',
    ColorTools.createPrimarySwatch(const Color(0xff387002)): 'LightGreenDark',
    ColorTools.createPrimarySwatch(const Color(0xff9e9d24)): 'Lime',
    ColorTools.createPrimarySwatch(const Color(0xff7c8500)): 'LimeDark',
    ColorTools.createPrimarySwatch(const Color(0xfff9a825)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xffc49000)): 'YellowDark',
    ColorTools.createPrimarySwatch(const Color(0xffff8f00)): 'Amber',
    ColorTools.createPrimarySwatch(const Color(0xffc67100)): 'AmberDark',
    ColorTools.createPrimarySwatch(const Color(0xffef6c00)): 'Orange',
    ColorTools.createPrimarySwatch(const Color(0xffbb4d00)): 'OrangeDark',
    ColorTools.createPrimarySwatch(const Color(0xffe64a19)): 'DeepOrange',
    ColorTools.createPrimarySwatch(const Color(0xffac0800)): 'DeepOrangeDark',
    ColorTools.createPrimarySwatch(const Color(0xff5d4037)): 'Brown',
    ColorTools.createPrimarySwatch(const Color(0xff321911)): 'BrownDark',
    ColorTools.createPrimarySwatch(const Color(0xff616161)): 'Grey',
    ColorTools.createPrimarySwatch(const Color(0xff373737)): 'GreyDark',
    ColorTools.createPrimarySwatch(const Color(0xff455a64)): 'BlueGrey',
    ColorTools.createPrimarySwatch(const Color(0xff1c313a)): 'BlueGreyDark',
  };
}
