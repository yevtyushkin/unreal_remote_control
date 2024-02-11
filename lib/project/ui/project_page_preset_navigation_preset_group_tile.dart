import 'package:flutter/material.dart';
import 'package:unreal_remote_control/project/domain/preset_group.dart';

/// A widget that displays the preset group tile.
class ProjectPagePresetNavigationPresetGroupTile extends StatelessWidget {
  /// A [PresetGroup] of this [ProjectPagePresetNavigationPresetGroupTile].
  final PresetGroup group;

  /// Returns a new instance of the [ProjectPagePresetNavigationPresetGroupTile]
  /// with the given [group].
  const ProjectPagePresetNavigationPresetGroupTile({
    required this.group,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(group.name),
      children: [
        ...group.exposedProperties.map(
          (property) => ListTile(
            title: Text(property.displayName),
          ),
        ),
        ...group.exposedFunctions.map(
          (function) => ListTile(
            title: Text(function.displayName),
          ),
        ),
      ],
    );
  }
}
