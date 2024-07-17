import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_selection_dropdown.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the project's page app bar.
class ProjectPageAppBar extends ConsumerWidget {
  /// Returns a new instance of the [ProjectPageAppBar].
  const ProjectPageAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProjectName = ref.watch(
      projectPageNotifierProvider.select(
        (notifier) => notifier.state.selectedProject?.name ?? '',
      ),
    );

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(selectedProjectName),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProjectPagePresetSelectionDropdown(),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 1,
      shadowColor: Colors.black,
    );
  }
}
