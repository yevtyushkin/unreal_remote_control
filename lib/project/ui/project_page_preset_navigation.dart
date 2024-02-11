import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_navigation_preset_group_tile.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_navigation_search_bar.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the preset navigation overview.
class ProjectPagePresetNavigation extends HookConsumerWidget {
  /// Returns a new instance of the [ProjectPagePresetNavigation].
  const ProjectPagePresetNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPreset = ref.watch(
      projectPageNotifierProvider.select(
        (provider) => provider.selectedPreset,
      ),
    );

    if (selectedPreset == null) {
      return const SizedBox();
    }

    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 12.0),
          sliver: ProjectPagePresetNavigationSearchBar(),
        ),
        SliverList.builder(
          itemCount: selectedPreset.groups.length,
          itemBuilder: (_, i) {
            final group = selectedPreset.groups[i];

            return ProjectPagePresetNavigationPresetGroupTile(group: group);
          },
        ),
      ],
    );
  }
}
