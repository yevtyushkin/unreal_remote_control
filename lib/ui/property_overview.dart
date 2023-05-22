import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/ui/property_value_editor.dart';

class ExposedPropertyOverview extends StatelessWidget {
  const ExposedPropertyOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final property = context.select((RemoteControl rc) => rc.exposedProperty);

    if (property == null) {
      return const Center(
        child: Text('No property selected'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              property.displayName,
              style: const TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Tooltip(
                message: const JsonEncoder.withIndent('   ').convert(property),
                child: const Icon(Icons.info, size: 16, color: Colors.grey),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Value (${property.underlyingProperty.type})',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: PropertyValueEditor(),
        )
      ],
    );
  }
}
