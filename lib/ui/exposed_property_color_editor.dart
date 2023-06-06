import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';
import 'package:unreal_remote_control/ui/exposed_property_button_bar.dart';

//TODO: refactor
class ExposedPropertyColorEditor extends StatefulWidget {
  const ExposedPropertyColorEditor({Key? key}) : super(key: key);

  @override
  State<ExposedPropertyColorEditor> createState() => _ExposedPropertyColorEditorState();
}

class _ExposedPropertyColorEditorState extends State<ExposedPropertyColorEditor> {
  late final RemoteControl _rc;
  SelectedProperty? _cachedValue;
  Color _color = Colors.white;
  final TextEditingController _r = TextEditingController();
  final TextEditingController _rD = TextEditingController();
  final TextEditingController _g = TextEditingController();
  final TextEditingController _gD = TextEditingController();
  final TextEditingController _b = TextEditingController();
  final TextEditingController _bD = TextEditingController();
  final TextEditingController _a = TextEditingController();
  final TextEditingController _aD = TextEditingController();

  @override
  void initState() {
    super.initState();

    _rc = context.read<RemoteControl>();
    _updateSelectedPropertyColor();

    _rc.addListener(_listenToColorUpdates);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ColorPicker(
              pickerColor: _color,
              onColorChanged: (color) => {
                setState(() {
                  _updateColor(color);
                })
              },
              paletteType: PaletteType.hueWheel,
              displayThumbColor: false,
              enableAlpha: true,
              labelTypes: const [],
            ),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: _r,
                    decoration: const InputDecoration(
                      label: Text('R'),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) => _changeComponentValue(
                      (color, channelValue) => color.withRed(channelValue),
                      value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _g,
                      decoration: const InputDecoration(
                        label: Text('G'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeComponentValue(
                        (color, channelValue) => color.withGreen(channelValue),
                        value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _b,
                      decoration: const InputDecoration(
                        label: Text('B'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeComponentValue(
                        (color, channelValue) => color.withBlue(channelValue),
                        value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _a,
                      decoration: const InputDecoration(
                        label: Text('A'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeComponentValue(
                        (color, channelValue) => color.withAlpha(channelValue),
                        value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: _rD,
                    decoration: const InputDecoration(
                      label: Text('R (Decimal)'),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) => _changeDecimalComponentValue(
                      (color, channelValue) => color.withRed(channelValue),
                      value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _gD,
                      decoration: const InputDecoration(
                        label: Text('G (Decimal)'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeDecimalComponentValue(
                        (color, channelValue) => color.withGreen(channelValue),
                        value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _bD,
                      decoration: const InputDecoration(
                        label: Text('B (Decimal)'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeDecimalComponentValue(
                        (color, channelValue) => color.withBlue(channelValue),
                        value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      controller: _aD,
                      decoration: const InputDecoration(
                        label: Text('A (Decimal)'),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) => _changeDecimalComponentValue(
                        (color, channelValue) => color.withAlpha(channelValue),
                        value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExposedPropertyButtonBar(
          onApply: _applyColor,
          onReset: () => _cachedValue = null,
          applyEnabled: true,
        ),
      ],
    );
  }

  void _listenToColorUpdates() {
    _updateSelectedPropertyColor();
    setState(() {});
  }

  void _applyColor() {
    final value = _cachedValue?.property.underlyingProperty.type == 'FColor'
        ? {
            'R': _color.red,
            'G': _color.green,
            'B': _color.blue,
            'A': _color.alpha,
          }
        : {
            'R': _color.red.toDouble() / 255,
            'G': _color.green.toDouble() / 255,
            'B': _color.blue.toDouble() / 255,
            'A': _color.alpha.toDouble() / 255,
          };

    _rc.applyPropertyValue(jsonEncode(value));
  }

  void _updateSelectedPropertyColor() {
    final selectedField = _rc.state.selectedPresetGroupField;
    if (selectedField is SelectedProperty) {
      if (_cachedValue != selectedField) {
        switch ((selectedField.value, selectedField.property.underlyingProperty.type)) {
          case ({'R': int r, 'G': int g, 'B': int b, 'A': int a}, 'FColor'):
            _updateColor(Color.fromARGB(a, r, g, b));
            _cachedValue = selectedField;
          case ({'R': num r, 'G': num g, 'B': num b, 'A': num a}, 'FLinearColor'):
            _updateColor(Color.fromARGB((a * 255).toInt(), (r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt()));
            _cachedValue = selectedField;
          case _:
            print(selectedField.value);
            print(selectedField.value.runtimeType);
        }
      }
    }
  }

  void _updateColor(Color color) {
    _color = color;
    _r.text = _valueIntoString(color.red);
    _rD.text = color.red.toString();
    _g.text = _valueIntoString(color.green);
    _gD.text = color.green.toString();
    _b.text = _valueIntoString(color.blue);
    _bD.text = color.blue.toString();
    _a.text = _valueIntoString(color.alpha);
    _aD.text = color.alpha.toString();
  }

  void _changeComponentValue(Color Function(Color, int) update, String value) {
    final asDouble = double.tryParse(value);
    if (asDouble != null && asDouble >= 0 && asDouble <= 1) {
      final newColor = update(_color, (asDouble * 255).toInt());
      setState(() {
        _updateColor(newColor);
      });
    }
  }

  void _changeDecimalComponentValue(Color Function(Color, int) update, String value) {
    final asInt = int.tryParse(value);
    if (asInt != null && asInt >= 0 && asInt <= 255) {
      final newColor = update(_color, asInt);
      setState(() {
        _updateColor(newColor);
      });
    }
  }

  String _valueIntoString(int value) => (value.toDouble() / 255).toStringAsPrecision(5);

  @override
  void dispose() {
    super.dispose();
    _rc.removeListener(_listenToColorUpdates);
  }
}
