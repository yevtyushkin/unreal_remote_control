import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';

class CreateNewAppDialog extends StatelessWidget {
  const CreateNewAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedProject = context.select((ProjectsNotifier notifier) => notifier.state.selectedProject);

    if (selectedProject == null) {
      return const SizedBox();
    }

    return const ContentDialog(
      title: Text('Create new app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            placeholder: 'Name',
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: TextBox(
              placeholder: 'URL',
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}
