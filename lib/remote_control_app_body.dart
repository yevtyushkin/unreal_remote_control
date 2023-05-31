import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/common/ui/toggleable_tooltip.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/projects/ui/projects_page.dart';
import 'package:unreal_remote_control/strings.dart';

class RemoteControlAppBody extends StatefulWidget {
  const RemoteControlAppBody({Key? key}) : super(key: key);

  @override
  State<RemoteControlAppBody> createState() => _RemoteControlAppBodyState();
}

class _RemoteControlAppBodyState extends State<RemoteControlAppBody> {
  static const _defaultPaneBodyPadding = EdgeInsets.all(8.0);
  static const _projectsPaneIndex = 0;

  int _selectedPaneItemIndex = _projectsPaneIndex;

  late final ProjectsNotifier _projectsNotifier;

  @override
  void initState() {
    super.initState();

    _projectsNotifier = context.read<ProjectsNotifier>();
    _projectsNotifier.addListener(_listenToSelectedProject);
  }

  @override
  Widget build(BuildContext context) {
    final projectSelected = _projectsNotifier.projectSelected;

    return NavigationView(
      transitionBuilder: (child, animation) => DrillInPageTransition(animation: animation, child: child),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        onChanged: (index) => setState(() => _selectedPaneItemIndex = index),
        selected: _selectedPaneItemIndex,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.project_collection),
            title: const Text(Strings.projects),
            body: const ProjectsPage(),
          ),
          PaneItem(
            icon: ToggleableTooltip(
              message: Strings.selectProjectToUseControls,
              enabled: !projectSelected,
              child: const Icon(FluentIcons.settings),
            ),
            title: const Text(Strings.controls),
            body: const Placeholder(),
            trailing: projectSelected
                ? null
                : const Tooltip(
                    message: Strings.selectProjectToUseControls,
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(FluentIcons.warning, color: Colors.warningPrimaryColor),
                  ),
            enabled: projectSelected,
          ),
        ],
      ),
    );
  }

  void _listenToSelectedProject() {
    if (!_projectsNotifier.projectSelected) {
      setState(() {
        _selectedPaneItemIndex = _projectsPaneIndex;
      });
    }
  }

  @override
  void dispose() {
    _projectsNotifier.removeListener(_listenToSelectedProject);

    super.dispose();
  }
}
