import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/common/ui/size_extension.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the edit/create project dialog.
class ProjectsPageProjectDialog extends HookConsumerWidget {
  /// An optional [Project] if this is an editing dialog.
  final Project? project;

  /// Returns a new instance of [ProjectsPageProjectDialog] with the given
  /// [project].
  const ProjectsPageProjectDialog({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = context.screenSize;

    final title =
        project == null ? 'Create project' : 'Edit project ${project?.name}';

    final projectName = project?.name ?? 'New project';
    final projectNameController = useTextEditingController(text: projectName);

    final connectionUrl = project?.connectionUrl;
    final connectionUrlController = useTextEditingController(
      text: connectionUrl,
    );

    final createOrSaveButtonTitle = project == null ? 'Create' : 'Save';

    return SizedBox.expand(
      child: AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: size.width * 0.6,
          height: size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project name',
                ),
                controller: projectNameController,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Connection URL',
                ),
                controller: connectionUrlController,
              ),
            ],
          ),
        ),
        actions: [
          ButtonBar(
            children: [
              TextButton(
                onPressed: () => _closeDialog(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () => _createOrSaveProject(
                  ref,
                  projectNameController,
                  connectionUrlController,
                  context,
                ),
                child: Text(createOrSaveButtonTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Pops this [ProjectsPageProjectDialog].
  void _closeDialog(BuildContext context) {
    context.pop();
  }

  /// Edits this dialog's [project] if it's not null.
  /// Creates a new [Project] if this dialog's [project] is null.
  void _createOrSaveProject(
    WidgetRef ref,
    TextEditingController projectNameController,
    TextEditingController connectionUrlController,
    BuildContext context,
  ) {
    final projectsNotifier = ref.read(projectsPageNotifierProvider);

    final project_ = project;
    if (project_ == null) {
      projectsNotifier.createProject(
        projectNameController.text,
        connectionUrlController.text,
      );
    } else {
      projectsNotifier.editProject(
        project_.id,
        projectNameController.text,
        connectionUrlController.text,
      );
    }

    context.pop();
  }
}
