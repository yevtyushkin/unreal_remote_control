import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/projects/ui/select_project_dialog.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: const EdgeInsets.only(top: 16.0),
      content: TabView(
        currentIndex: 0,
        onNewPressed: () => _showProjectSelectionDialog(context),
        onChanged: (_) {},
        onReorder: (_, __) {},
        tabWidthBehavior: TabWidthBehavior.equal,
        shortcutsEnabled: true,
        tabs: [],
      ),
    );
  }

  Future<void> _showProjectSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<ProjectsNotifier>(),
        child: const SelectProjectDialog(),
      ),
      barrierDismissible: true,
    );
  }
}
