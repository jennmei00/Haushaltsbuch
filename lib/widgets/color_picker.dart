import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerClass extends StatelessWidget {
  final Function onColorChanged;
  final Color color;

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
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      heading: Text('Wähle eine Farbe'),
      subheading: Text('Wähle eine Farbschattierung'),
      wheelSubheading: Text('Schattierungen der gewählten Farbe'),
      wheelWidth: 16,
      columnSpacing: 10,
      enableOpacity: true,
      opacityTrackHeight: 14,
      color: color,
    );
  }
}
