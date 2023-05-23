import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';

class ExposedFunctionOverview extends StatelessWidget {
  const ExposedFunctionOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = context.select((RemoteControl rc) => rc.state.selectedPresetGroupField);

    if (selected is! SelectedFunction) return const SizedBox();

    final supported = selected.function.underlyingFunction.arguments.isEmpty;

    return TextButton.icon(
      onPressed: supported ? context.read<RemoteControl>().callSelectedFunction : null,
      icon: const Icon(Icons.send, color: Colors.blue),
      label: const Text('Call function'),
    );
  }
}
