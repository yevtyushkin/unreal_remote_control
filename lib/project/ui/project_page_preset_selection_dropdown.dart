import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the project page preset selection dropdown.
class ProjectPagePresetSelectionDropdown extends ConsumerWidget {
  /// Returns a new instance of the [ProjectPagePresetSelectionDropdown].
  const ProjectPagePresetSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(
      projectPageNotifierProvider.select(
        (notifier) => notifier.state.presets,
      ),
    );

    final selectedPreset = ref.watch(
      projectPageNotifierProvider.select(
        (notifier) => notifier.state.selectedPreset,
      ),
    );

    return DropdownButton<Preset>(
      value: selectedPreset,
      items: [
        ...presets.map(
          (preset) {
            return DropdownMenuItem(
              value: preset,
              child: Text(preset.name),
            );
          },
        ),
      ],
      onChanged: (preset) => _selectPreset(ref, preset),
    );
  }

  /// Handles the preset selection using given selected [preset].
  void _selectPreset(WidgetRef ref, Preset? preset) {
    ref.read(projectPageNotifierProvider).selectPreset(preset);
  }
}
