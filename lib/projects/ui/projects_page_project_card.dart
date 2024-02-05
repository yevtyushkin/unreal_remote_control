import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_delete_project_dialog.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_project_dialog.dart';

/// A widget that displays the given [project] as a [Card].
class ProjectsPageProjectCard extends HookConsumerWidget {
  /// A [Project] this [Card] displays.
  final Project project;

  /// Returns a new instance of the [ProjectsPageProjectCard] with the given
  /// [project].
  const ProjectsPageProjectCard({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);

    return InkWell(
      onHover: (newHoverValue) => isHovered.value = newHoverValue,
      onTap: _selectProject,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.7,
              ),
            ),
            child: Center(
              child: Text(project.name),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: MenuAnchor(
              builder: (_, controller, __) {
                final isOpen = controller.isOpen;

                return IconButton(
                  onPressed: isOpen ? controller.close : controller.open,
                  icon: const Icon(Icons.more_horiz),
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: () => _editProject(context),
                  trailingIcon: const Icon(Icons.edit),
                  child: const Text('Edit'),
                ),
                MenuItemButton(
                  onPressed: () => _deleteProject(context),
                  trailingIcon: const Icon(Icons.delete),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the [ProjectsPageProjectDialog] for editing this card's [project].
  void _editProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ProjectsPageProjectDialog(project: project),
    );
  }

  /// Opens the [ProjectsPageDeleteProjectDialog] for deleting this card's
  /// [project].
  void _deleteProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ProjectsPageDeleteProjectDialog(project: project),
    );
  }

  /// Selects and navigates to the given [project].
  void _selectProject() {}
}
