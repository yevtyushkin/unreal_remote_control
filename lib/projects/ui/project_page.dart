import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/projects/ui/create_new_app_dialog.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedProject = context.select((ProjectsNotifier notifier) => notifier.state.selectedProject);

    if (selectedProject == null) {
      return const SizedBox();
    }

    return NavigationView(
      appBar: NavigationAppBar(
        height: 72,
        title: Text(
          selectedProject.name,
          style: FluentTheme.of(context).typography.subtitle,
        ),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        items: [
          PaneItemAction(
            icon: const Icon(FluentIcons.add),
            title: const Text('Create new app'),
            onTap: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<ProjectsNotifier>(),
                child: const CreateNewAppDialog(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
