import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';

const _encoder = JsonEncoder.withIndent('      ');

class PropertyValueEditor extends StatefulWidget {
  const PropertyValueEditor({Key? key}) : super(key: key);

  @override
  State<PropertyValueEditor> createState() => _PropertyValueEditorState();
}

class _PropertyValueEditorState extends State<PropertyValueEditor> {
  final _formKey = UniqueKey();
  final _controller = TextEditingController();
  late final RemoteControl _remoteControl;
  dynamic _cachedValue;
  String? _valueError;
  String? _typeError;

  @override
  void initState() {
    super.initState();

    _remoteControl = context.read<RemoteControl>();

    _cachedValue = _remoteControl.state.exposedPropertyValue;
    _controller.text = _encoder.convert(_cachedValue);

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
          child: TextButton.icon(
            onPressed: _remoteControl.refreshPropertyValue,
            icon: const Icon(Icons.refresh, color: Colors.blue),
            label: const Text('Restore actual value'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextButton.icon(
            onPressed: _valueError == null
                ? () => _remoteControl.applyPropertyValue(_controller.text)
                : null,
            icon: Icon(Icons.send,
                color: _valueError == null ? Colors.green : Colors.grey),
            label: const Text('Apply new value'),
          ),
        ),
      ],
    );
  }

  void _onTextValueChanged() {
    try {
      final newValue = jsonDecode(_controller.text);
      _valueError = null;

      final initialValue = _remoteControl.state.exposedPropertyValue;
      if (initialValue.runtimeType != newValue.runtimeType) {
        _typeError =
            'WARN: Probably, the new value has a different type from the initial value';
      } else {
        _typeError = null;
      }

      if (initialValue is Map && newValue is Map) {
        final initialKeys = initialValue.keys.toSet();
        final actualKeys = newValue.keys.toSet();
        final diff = initialKeys.difference(actualKeys);
        if (diff.isNotEmpty) {
          _typeError =
              'The following keys might be missing in the new value: ${diff.map((k) => "'$k'").join(', ')}';
        }
      }
    } catch (_) {
      _valueError = 'This is not valid JSON / primitive';
    }

    setState(() {});
  }

  void _listenToValueUpdates() {
    final newValue = _remoteControl.state.exposedPropertyValue;
    if (_cachedValue != newValue) {
      _controller.text = _encoder.convert(newValue);
      _cachedValue = newValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _remoteControl.removeListener(_listenToValueUpdates);

    super.dispose();
  }
}
