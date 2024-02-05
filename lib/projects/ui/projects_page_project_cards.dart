import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_project_card.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays [Project] [Card]s.
class ProjectsPageProjectCards extends ConsumerWidget {
  /// Returns a new instance of the [ProjectsPageProjectCards].
  const ProjectsPageProjectCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(
      projectsPageNotifierProvider.select(
        (notifier) => notifier.projects,
      ),
    );

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: projects.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, i) {
        final project = projects[i];

        return ProjectsPageProjectCard(project: project);
      },
    );
  }
}
