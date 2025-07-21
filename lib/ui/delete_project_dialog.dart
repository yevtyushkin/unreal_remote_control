import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';

class DeleteProjectDialog extends HookConsumerWidget {
  const DeleteProjectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(projectsNotifier);
    final projectName = notifier.selectedProject?.name ?? '';

    return AlertDialog(
      title: const Text('Delete Project'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to delete project "$projectName"?',
          ),
        ],
      ),
      actions: [
        Button.destructive(
          child: const Text('Delete'),
          onPressed: () {
            notifier.deleteCurrentProject();
            context.pop(true);
          },
        ),
      ],
    );
  }
}
