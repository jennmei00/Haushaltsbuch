import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:haushaltsbuch/services/globals.dart';

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
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: false,
      },
      // subheading: Text('Farbschattierung'),
      wheelWidth: 16,
      columnSpacing: 10,
      enableOpacity: false,
      opacityTrackHeight: 14,
      color: color,
      enableShadesSelection: false,
      customColorSwatchesAndNames:
          Globals.isDarkmode ? Globals.customSwatchDarkMode : Globals.customSwatchLightMode,
    );
  }
}
