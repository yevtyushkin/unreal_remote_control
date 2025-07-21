import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/connection_status.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';
import 'package:unreal_remote_control/ui/create_or_edit_project_dialog.dart';
import 'package:unreal_remote_control/ui/delete_project_dialog.dart';
import 'package:unreal_remote_control/ui/project_tuning.dart';

class ProjectPage extends HookConsumerWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (project, connectionStatus) = ref.watch(
      projectsNotifier.select(
        (notifier) => (
          notifier.selectedProject,
          notifier.connectionStatus,
        ),
      ),
    );

    return Scaffold(
      headers: [
        AppBar(
          leading: [
            IconButton.outline(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () {
                ref.read(projectsNotifier).selectProject(null);
                context.pop();
              },
            ),
          ],
          title: Row(
            children: [
              Text(project?.name ?? ''),
              const Gap(4),
              switch (connectionStatus) {
                Connecting() => Tooltip(
                    child: const CircularProgressIndicator(),
                    tooltip: (_) => const TooltipContainer(
                      child: Text('Connecting'),
                    ),
                  ),
                Connected() => Tooltip(
                    child: const Icon(
                      LucideIcons.wifi,
                      color: Colors.teal,
                    ),
                    tooltip: (_) => const TooltipContainer(
                      child: Text('Connected'),
                    ),
                  ),
                Failed(err: final e) => Tooltip(
                    child: const Icon(LucideIcons.wifiOff, color: Colors.red),
                    tooltip: (_) => TooltipContainer(
                      child: Text('Connection failed: $e'),
                    ),
                  ),
              },
            ],
          ),
          trailing: [
            Tooltip(
              tooltip: (_) => const TooltipContainer(
                child: Text('Edit project'),
              ),
              child: IconButton.ghost(
                icon: const Icon(LucideIcons.pencil),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => const CreateOrEditProjectDialog(),
                  );
                },
              ),
            ),
            Tooltip(
              tooltip: (_) => const TooltipContainer(
                child: Text('Refresh connection'),
              ),
              child: IconButton.ghost(
                icon: const Icon(LucideIcons.refreshCcw),
                onPressed: () {
                  ref.read(projectsNotifier).connect();
                },
              ),
            ),
            Tooltip(
              tooltip: (_) => const TooltipContainer(
                child: Text('Delete project'),
              ),
              child: IconButton.ghost(
                icon: const Icon(LucideIcons.trash2),
                onPressed: () async {
                  final deleted = await showDialog<bool>(
                    context: context,
                    builder: (_) => const DeleteProjectDialog(),
                  );
                  if ((deleted ?? false) && context.mounted) {
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ],
      child: const ProjectTuning(),
    );
  }
}
