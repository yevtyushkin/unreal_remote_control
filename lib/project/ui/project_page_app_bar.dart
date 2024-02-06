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

    final problematicConnectionUrl = ref.watch(
      projectPageNotifierProvider.select(
        (notifier) => notifier.state.problematicConnectionUrl,
      ),
    );

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(selectedProjectName),
          if (problematicConnectionUrl)
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Tooltip(
                message: 'The connection URL is either missing or incorrect',
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
      actions: const [
        ProjectPagePresetSelectionDropdown(),
      ],
      centerTitle: false,
      elevation: 8.0,
      shadowColor: Colors.black,
    );
  }
}
