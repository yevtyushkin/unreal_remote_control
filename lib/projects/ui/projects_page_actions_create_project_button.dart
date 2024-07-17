import 'package:flutter/material.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_project_dialog.dart';

/// A widget that displays the button which allows to open the project creation
/// dialog.
class ProjectsPageActionsCreateProjectButton extends StatelessWidget {
  /// Returns a new instance of the [ProjectsPageActionsCreateProjectButton].
  const ProjectsPageActionsCreateProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: 'Create new project',
      label: const Icon(Icons.add),
      onPressed: () => _onPressed(context),
    );
  }

  /// Opens the project creation dialog.
  void _onPressed(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const ProjectsPageProjectDialog(
        project: null,
      ),
    );
  }
}
