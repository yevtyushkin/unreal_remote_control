import 'package:flutter/material.dart';
import 'package:unreal_remote_control/project/domain/preset_group.dart';

/// A widget that displays the preset group tile.
class ProjectPagePresetNavigationPresetGroupTile extends StatelessWidget {
  /// Returns a new instance of the [ProjectPagePresetNavigationPresetGroupTile]
  /// with the given [group].
  const ProjectPagePresetNavigationPresetGroupTile({
    required this.group,
    super.key,
  });

  /// A [PresetGroup] of this [ProjectPagePresetNavigationPresetGroupTile].
  final PresetGroup group;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(group.name),
      children: [
        ...group.exposedProperties.map(
          (property) => ListTile(
            leading: const Icon(Icons.edit),
            title: Text(property.displayName),
            onTap: () {},
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
