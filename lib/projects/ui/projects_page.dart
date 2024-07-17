import 'package:flutter/material.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_actions.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_project_cards.dart';

/// A widget that displays the projects page.
class ProjectsPage extends StatelessWidget {
  /// Returns a new instance of the [ProjectsPage].
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(height: 48),
            child: const ProjectsPageActions(),
          ),
          const Expanded(
            child: ProjectsPageProjectCards(),
          ),
        ],
      ),
    );
  }
}
