import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';
import 'package:unreal_remote_control/ui/exposed_property_button_bar.dart';

const _encoder = JsonEncoder.withIndent('      ');

class ExposedPropertyValueEditor extends StatefulWidget {
  const ExposedPropertyValueEditor({Key? key}) : super(key: key);

  @override
  State<ExposedPropertyValueEditor> createState() => _ExposedPropertyValueEditorState();
}

class _ExposedPropertyValueEditorState extends State<ExposedPropertyValueEditor> {
  final _formKey = UniqueKey();
  final _controller = TextEditingController();
  late final RemoteControl _remoteControl;
  dynamic _currentValue;
  String? _valueError;
  String? _typeError;

  @override
  void initState() {
    super.initState();

    _remoteControl = context.read<RemoteControl>();

    _updateCurrentValue();
    _controller.text = _encoder.convert(_currentValue);

    _controller.addListener(_onTextValueChanged);
    _remoteControl.addListener(_listenToValueUpdates);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: _formKey,
          maxLines: null,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText: _valueError,
            helperText: _typeError,
            helperStyle: const TextStyle(color: Colors.orange),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _controller,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ExposedPropertyButtonBar(
            applyEnabled: _valueError == null,
            onApply: () => _remoteControl.applyPropertyValue(_controller.text),
          ),
        ),
      ],
    );
  }

  void _onTextValueChanged() {
    try {
      final newValue = jsonDecode(_controller.text);
      _valueError = null;

      if (_currentValue.runtimeType != newValue.runtimeType) {
        _typeError = 'WARN: Probably, the new value has a different type from the initial value';
      } else {
        _typeError = null;
      }

      if (_currentValue is Map && newValue is Map) {
        final initialKeys = _currentValue.keys.toSet();
        final actualKeys = newValue.keys.toSet();
        final diff = initialKeys.difference(actualKeys);
        if (diff.isNotEmpty) {
          _typeError = 'The following keys might be missing in the new value: ${diff.map((k) => "'$k'").join(', ')}';
        }
      }
    } catch (_) {
      _valueError = 'This is not valid JSON / primitive';
    }

    setState(() {});
  }

  void _listenToValueUpdates() {
    final valueBeforeUpdate = _currentValue;
    _updateCurrentValue();

    if (_currentValue != valueBeforeUpdate) {
      _controller.text = _encoder.convert(_currentValue);
    }
  }

  void _updateCurrentValue() {
    final selectedField = _remoteControl.state.selectedPresetGroupField;
    if (selectedField is SelectedProperty) {
      _currentValue = selectedField.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _remoteControl.removeListener(_listenToValueUpdates);

    super.dispose();
  }
}
