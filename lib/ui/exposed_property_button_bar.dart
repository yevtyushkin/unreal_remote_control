import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';

class ExposedPropertyButtonBar extends StatelessWidget {
  const ExposedPropertyButtonBar({Key? key, required this.onApply, required this.applyEnabled}) : super(key: key);

  final VoidCallback onApply;
  final bool applyEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: context.read<RemoteControl>().refreshPropertyValue,
          icon: const Icon(Icons.refresh, color: Colors.blue),
          label: const Text('Restore actual value'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextButton.icon(
            onPressed: onApply,
            icon: Icon(Icons.send, color: applyEnabled ? Colors.green : Colors.grey),
            label: const Text('Apply new value'),
          ),
        )
      ],
    );
  }
}
