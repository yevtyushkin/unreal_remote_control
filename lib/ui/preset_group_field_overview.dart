import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';
import 'package:unreal_remote_control/ui/exposed_function_overview.dart';
import 'package:unreal_remote_control/ui/exposed_property_color_editor.dart';
import 'package:unreal_remote_control/ui/exposed_property_value_editor.dart';

const _encoder = JsonEncoder.withIndent('   ');

class PresetGroupFieldOverview extends StatelessWidget {
  const PresetGroupFieldOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = context.select(
      (RemoteControl rc) => rc.state.selectedPresetGroupField,
    );

    if (selected == null) {
      return const Center(
        child: Text('No property or function is selected'),
      );
    }

    final (
      name,
      asJson,
      typeOverview,
    ) = switch (selected) {
      SelectedProperty p => (
          p.property.displayName,
          _encoder.convert(p.property),
          'Property (${p.property.underlyingProperty.type})'
        ),
      SelectedFunction f => (
          f.function.displayName,
          _encoder.convert(f.function),
          'Function (${f.function.underlyingFunction.arguments.length} arguments)'
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Tooltip(
                message: asJson,
                child: const Icon(Icons.info, size: 16, color: Colors.grey),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            typeOverview,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: selected is SelectedProperty
              ? (const {'FColor', 'FLinearColor'}.contains(selected.property.underlyingProperty.type)
                  ? const ExposedPropertyColorEditor()
                  : const ExposedPropertyValueEditor())
              : const ExposedFunctionOverview(),
        )
      ],
    );
  }
}
