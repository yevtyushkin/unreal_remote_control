import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';
import 'package:unreal_remote_control/router.dart';
import 'package:unreal_remote_control/ui/create_or_edit_project_dialog.dart';

class ProjectSelectionPage extends HookConsumerWidget {
  const ProjectSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter for the project name.
    final projectNameFilter = useState('');
    // Text editing controller for the project name filter.
    final controller = useTextEditingController();

    // Watches for [ProjectModel] changes, and filters them using
    // [projectNameFilter].
    final projects = ref.watch(
      projectsNotifier.select(
        (notifier) => notifier.projects
            .where(
              (project) => project.name.toLowerCase().contains(
                    projectNameFilter.value.toLowerCase(),
                  ),
            )
            .toList(),
      ),
    );

    return Scaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              initialValue: projectNameFilter.value,
              onChanged: (value) => projectNameFilter.value = value,
              controller: controller,
              features: [
                const InputFeature.leading(Icon(LucideIcons.search)),
                InputFeature.clear(
                  icon: GestureDetector(
                    onTap: () {
                      projectNameFilter.value = '';
                      controller.clear();
                    },
                    child: const Icon(LucideIcons.x),
                  ),
                ),
              ],
              placeholder: const Text('Type to search'),
            ),
            const Gap(24),
            Expanded(
              child: GridView.builder(
                itemCount: projects.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, i) {
                  final project = i == 0 ? null : projects[i - 1];
                  final title = project?.name ?? 'Create project';

                  return CardButton(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title),
                          if (project == null)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(LucideIcons.plus),
                            ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      if (project == null) {
                        showDialog<void>(
                          context: context,
                          builder: (context) {
                            return const CreateOrEditProjectDialog();
                          },
                        );
                      } else {
                        ref.read(projectsNotifier).selectProject(project);
                        context.push(projectRoute);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
