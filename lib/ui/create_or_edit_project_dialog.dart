import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/project.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';

class CreateOrEditProjectDialog extends HookConsumerWidget {
  const CreateOrEditProjectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(projectsNotifier);
    final selectedProject = notifier.selectedProject;

    final projectState = useState(selectedProject ?? Project.empty());

    final title = selectedProject == null ? 'Create project' : 'Edit project';
    final buttonTitle = selectedProject == null ? 'Create' : 'Save';

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormTableLayout(
            spacing: 16,
            rows: [
              FormField<String>(
                key: const TextFieldKey(#projectName),
                label: const Text('Project name'),
                child: TextField(
                  initialValue: projectState.value.name,
                  onChanged: (name) {
                    projectState.value = projectState.value.copyWith(
                      name: name,
                    );
                  },
                ),
              ),
              FormField<String>(
                key: const TextFieldKey(#projectUrl),
                label: const Text('Project URL'),
                child: TextField(
                  maxLines: 3,
                  minLines: 3,
                  initialValue: projectState.value.url,
                  onChanged: (url) {
                    projectState.value = projectState.value.copyWith(
                      url: url,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        PrimaryButton(
          child: Text(buttonTitle),
          onPressed: () {
            notifier.createOrUpdateProject(projectState.value);
            context.pop();
          },
        ),
      ],
    );
  }
}
