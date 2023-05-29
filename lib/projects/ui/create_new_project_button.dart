import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/projects/state/projects_notifier.dart';
import 'package:unreal_remote_control/strings.dart';

class CreateNewProjectButton extends StatefulWidget {
  const CreateNewProjectButton({Key? key}) : super(key: key);

  @override
  State<CreateNewProjectButton> createState() => _CreateNewProjectButtonState();
}

class _CreateNewProjectButtonState extends State<CreateNewProjectButton> {
  bool _textMode = false;
  String? _projectName;
  String? _error = Strings.projectNameCantBeEmpty;

  @override
  Widget build(BuildContext context) {
    if (_textMode) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: TextBox(
          placeholder: Strings.enterProjectName,
          suffix: _error == null
              ? FilledButton(
                  onPressed: _createProject,
                  child: const Text(Strings.save),
                )
              : Tooltip(
                  message: _error,
                  child: const Icon(
                    FluentIcons.error,
                    color: Colors.warningPrimaryColor,
                  ),
                ),
          onChanged: _onProjectNameChanged,
          onSubmitted: (_) => _createProject(),
        ),
      );
    }

    return Button(
      child: const Text(Strings.createProject),
      onPressed: () => setState(() => _textMode = true),
    );
  }

  void _onProjectNameChanged(String name) {
    name = name.trim();
    _projectName = name;

    if (name.isEmpty) {
      setState(() {
        _error = Strings.projectNameCantBeEmpty;
      });
      return;
    }

    final projectExists = context.read<ProjectsNotifier>().state.allProjects.any((project) => project.name == name);
    if (projectExists) {
      _error = Strings.projectWithThisNameExists;
    } else {
      _error = null;
    }

    setState(() {});
  }

  Future<void> _createProject() async {
    final projectName = _projectName;
    if (projectName == null || _error != null) return;
    await context.read<ProjectsNotifier>().createProject(projectName);
  }
}
