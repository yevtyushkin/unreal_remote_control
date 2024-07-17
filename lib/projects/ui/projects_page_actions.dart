import 'package:flutter/material.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_actions_create_project_button.dart';
import 'package:unreal_remote_control/projects/ui/projects_page_actions_search_bar.dart';

/// A widget that displays the actions of the projects page.
class ProjectsPageActions extends StatelessWidget {
  /// Returns a new instance of the [ProjectsPageActions].
  const ProjectsPageActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ProjectsPageActionsCreateProjectButton(),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: ProjectsPageActionsSearchBar(),
        ),
      ],
    );
  }
}
