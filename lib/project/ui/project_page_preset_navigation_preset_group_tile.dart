import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/project/domain/preset_group.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the preset group tile.
class ProjectPagePresetNavigationPresetGroupTile extends ConsumerWidget {
  /// Returns a new instance of the [ProjectPagePresetNavigationPresetGroupTile]
  /// with the given [group].
  const ProjectPagePresetNavigationPresetGroupTile({
    required this.group,
    super.key,
  });

  /// A [PresetGroup] of this [ProjectPagePresetNavigationPresetGroupTile].
  final PresetGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: Text(group.name),
      children: [
        ...group.exposedProperties.map(
          (property) => ListTile(
            leading: const Icon(Icons.edit),
            title: Text(property.displayName),
            onTap: () => ref.read(projectPageNotifierProvider).selectProperty(property),
          ),
        ),
        ...group.exposedFunctions.map(
          (function) => ListTile(
            leading: const Icon(Icons.settings_remote),
            title: Text(function.displayName),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
