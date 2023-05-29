import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/projects/ui/create_new_project_button.dart';
import 'package:unreal_remote_control/strings.dart';

class SelectProjectDialog extends StatelessWidget {
  const SelectProjectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allProjects = context.select(
      (ProjectsNotifier notifier) => notifier.state.allProjects,
    );

    return ContentDialog(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.selectProject),
          Spacer(),
          CreateNewProjectButton(),
        ],
      ),
      constraints: const BoxConstraints.expand(),
      content: GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 16),
        crossAxisCount: 3,
        childAspectRatio: 2,
        mainAxisSpacing: 32,
        crossAxisSpacing: 32,
        children: [
          ...allProjects.map(
            (project) => HoverButton(
              onPressed: () {},
              builder: (context, state) {
                final isHovered = state.contains(ButtonStates.hovering);
                return Stack(
                  children: [
                    Card(
                      borderColor: isHovered ? FluentTheme.of(context).accentColor : null,
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
                          onPressed: () {},
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
