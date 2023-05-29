import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/model/project.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/strings.dart';

class DeleteProjectDialog extends StatelessWidget {
  const DeleteProjectDialog({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(Strings.deleteProject(project.name)),
      content: Text(Strings.deleteProjectDescription(project.name)),
      actions: [
        FilledButton(
          onPressed: () => _delete(context),
          style: ButtonStyle(
            backgroundColor: ButtonState.resolveWith(
              (states) => states.contains(ButtonStates.hovering) ? Colors.red.dark : Colors.red.normal,
            ),
          ),
          child: const Text(Strings.delete),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
      ],
    );
  }

  void _delete(BuildContext context) async {
    context.read<ProjectsNotifier>().deleteProject(project);
    Navigator.maybePop(context);
  }
}
