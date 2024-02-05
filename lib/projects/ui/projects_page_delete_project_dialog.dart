import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the delete project dialog.
class ProjectsPageDeleteProjectDialog extends ConsumerWidget {
  /// A project ID
  final Project project;

  /// Returns a new instance of the [ProjectsPageDeleteProjectDialog].
  const ProjectsPageDeleteProjectDialog({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = project.name;
    final id = project.id;

    return AlertDialog(
      title: Text('Delete project $name'),
      content: Text(
        'Are you sure about deleting the project $name (ID: $id)?\n'
        'This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => _closeDialog(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _deleteProject(ref, context),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  /// Closes this delete project dialog.
  void _closeDialog(BuildContext context) {
    context.pop();
  }

  /// Deletes this delete dialog's [project].
  void _deleteProject(WidgetRef ref, BuildContext context) {
    ref.read(projectsPageNotifierProvider).deleteProject(project.id);

    context.pop();
  }
}
