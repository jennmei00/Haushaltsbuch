import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerClass extends StatelessWidget {
  final Function onColorChanged;
  final Color color;
  final Map<ColorSwatch<Object>, String> customSwatches =
<ColorSwatch<Object>, String>{
  const MaterialColor(0xFFfae738, <int, Color>{
    50: Color(0xFFfffee9),
    100: Color(0xFFfff9c6),
    200: Color(0xFFfff59f),
    300: Color(0xFFfff178),
    400: Color(0xFFfdec59),
    500: Color(0xFFfae738),
    600: Color(0xFFf3dd3d),
    700: Color(0xFFdfc735),
    800: Color(0xFFcbb02f),
    900: Color(0xFFab8923),
  }): 'Alpine',
  ColorTools.createPrimarySwatch(const Color(0xFFBC350F)): 'Rust',
  ColorTools.createAccentSwatch(const Color(0xFFB062DB)): 'Lavender',
  ColorTools.createPrimarySwatch(const Color(0xffc41b00)): 'Test',
};

  ColorPickerClass(this.onColorChanged, this.color);

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      onColorChanged: (value) => onColorChanged(value),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      //heading: Text('Wähle eine Farbe'),
      subheading: Text('Farbschattierung'),
      //wheelSubheading: Text('Schattierungen der gewählten Farbe'),
      wheelWidth: 16,
      columnSpacing: 10,
      enableOpacity: true,
      opacityTrackHeight: 14,
      color: color,
      enableShadesSelection: true,
      customColorSwatchesAndNames: customSwatches,
    );
  }
}
