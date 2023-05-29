import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/projects/ui/create_new_project_button.dart';
import 'package:unreal_remote_control/projects/ui/delete_project_dialog.dart';
import 'package:unreal_remote_control/strings.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (allProjects, selectedProject) = context.select(
      (ProjectsNotifier notifier) => (notifier.state.allProjects, notifier.state.selectedProject),
    );

    return ScaffoldPage(
      header: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52.0),
        child: PageHeader(
          title: Text(Strings.selectProject, style: FluentTheme.of(context).typography.subtitle),
          commandBar: const CreateNewProjectButton(),
        ),
      ),
      content: GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        crossAxisCount: 3,
        childAspectRatio: 2,
        mainAxisSpacing: 32,
        crossAxisSpacing: 32,
        children: [
          ...allProjects.map(
            (project) => HoverButton(
              onPressed: () => context.read<ProjectsNotifier>().toggleSelectedProject(project),
              builder: (context, state) {
                final isHovered = state.contains(ButtonStates.hovering);
                return Stack(
                  children: [
                    Card(
                      borderColor: selectedProject == project
                          ? FluentTheme.of(context).accentColor
                          : isHovered
                              ? Colors.grey[90]
                              : null,
                      child: Center(
                        child: Text(project.name),
                      ),
                    ),
                    if (isHovered)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(FluentIcons.delete),
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (dialogContext) => ChangeNotifierProvider.value(
                              value: context.read<ProjectsNotifier>(),
                              child: DeleteProjectDialog(project: project),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
