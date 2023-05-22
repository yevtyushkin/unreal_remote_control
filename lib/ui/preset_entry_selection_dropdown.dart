import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';

class PresetEntrySelectionDropdown extends StatelessWidget {
  const PresetEntrySelectionDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (presets, selected) = context
        .select((RemoteControl rc) => (rc.presetEntries, rc.presetEntry));

    return DropdownButton(
      hint: const Text('Select preset'),
      elevation: 0,
      value: selected,
      focusColor: Colors.transparent,
      items: [
        if (selected != null) null,
        ...presets,
      ]
          .map(
            (preset) => DropdownMenuItem(
              value: preset,
              child: Text(preset?.name ?? ''),
            ),
          )
          .toList(),
      onChanged: context.read<RemoteControl>().selectPresetEntry,
    );
  }
}
