import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/preset.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';
import 'package:unreal_remote_control/ui/function_invocation.dart';
import 'package:unreal_remote_control/ui/project_tuning_tree_view_node.dart';
import 'package:unreal_remote_control/ui/property_control.dart';

class ProjectTuning extends HookConsumerWidget {
  const ProjectTuning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(
      projectsNotifier.select(
        (notifier) => notifier.presets,
      ),
    );

    final expansions = useState(<ProjectTuningTreeViewNode>{});
    final search = useState('');
    final GlobalKey<WindowNavigatorHandle> windowKey = useMemoized(
      GlobalKey.new,
    );

    return ResizablePanel.horizontal(
      children: [
        ResizablePane.flex(
          initialFlex: 0.35,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  features: const [
                    InputFeature.leading(Icon(LucideIcons.search)),
                  ],
                  onChanged: (value) => search.value = value,
                  placeholder: const Text(
                    'Type to search',
                  ),
                ),
              ),
              Expanded(
                child: TreeView<ProjectTuningTreeViewNode>(
                  nodes: presetsToTreeViewItems(
                    presets,
                    expansions.value,
                    search.value,
                  ),
                  builder: (_, item) {
                    final icon = switch (item.data) {
                      PresetNode() => LucideIcons.folderTree,
                      PresetGroupNode() => LucideIcons.folder,
                      ExposedPropertyNode() => LucideIcons.slidersHorizontal,
                      ExposedFunctionNode() => LucideIcons.squareFunction,
                    };

                    final title = switch (item.data) {
                      PresetNode(:final preset) => preset.name,
                      PresetGroupNode(:final group) => group.name,
                      ExposedPropertyNode(:final property) =>
                        '${property.displayName} '
                            '(${property.underlyingProperty.type})',
                      ExposedFunctionNode(:final function) =>
                        function.displayName,
                    };

                    return TreeItemView(
                      expandable: !item.leaf,
                      onExpand: (isExpanded) {
                        final newExpansions = Set.of(expansions.value);
                        if (isExpanded) {
                          newExpansions.add(item.data);
                        } else {
                          newExpansions.remove(item.data);
                        }
                        expansions.value = newExpansions;
                      },
                      onPressed: () {
                        final data = item.data;
                        final Widget? content;
                        if (data is ExposedPropertyNode) {
                          ref
                              .read(projectsNotifier)
                              .fetchPropertyValue(data.preset, data.property);

                          content = PropertyControl(
                            preset: data.preset,
                            property: data.property,
                          );
                        } else if (data is ExposedFunctionNode) {
                          content = FunctionInvocation(
                            preset: data.preset,
                            function: data.function,
                          );
                        } else {
                          content = null;
                        }

                        if (content != null) {
                          windowKey.currentState?.pushWindow(
                            Window(
                              bounds: const Rect.fromLTWH(0, 0, 600, 550),
                              content: Center(child: content),
                              title: Text(title).xSmall,
                              maximizable: false,
                              minimizable: false,
                            ),
                          );
                        }
                      },
                      leading: Icon(icon),
                      child: Text(title),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ResizablePane.flex(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: WindowNavigator(
              key: windowKey,
              showTopSnapBar: false,
              initialWindows: const [],
            ),
          ),
        ),
      ],
    );
  }

  List<TreeNode<ProjectTuningTreeViewNode>> presetsToTreeViewItems(
    List<Preset> presets,
    Set<ProjectTuningTreeViewNode> expansions,
    String search,
  ) {
    final filteredPresets = presets
        .map((preset) {
          if (preset.name.toLowerCase().contains(search.toLowerCase())) {
            return preset;
          }

          final filteredGroups = preset.groups
              .map((group) {
                if (group.name.toLowerCase().contains(search.toLowerCase())) {
                  return group;
                }

                final filteredProperties = group.exposedProperties
                    .where(
                      (property) => property.displayName.toLowerCase().contains(
                            search.toLowerCase(),
                          ),
                    )
                    .toList();

                final filteredFunctions = group.exposedFunctions
                    .where(
                      (function) => function.displayName.toLowerCase().contains(
                            search.toLowerCase(),
                          ),
                    )
                    .toList();

                return group.copyWith(
                  exposedProperties: filteredProperties,
                  exposedFunctions: filteredFunctions,
                );
              })
              .where(
                (group) =>
                    group.exposedProperties.isNotEmpty ||
                    group.exposedFunctions.isNotEmpty,
              )
              .toList();

          return preset.copyWith(groups: filteredGroups);
        })
        .where((preset) => preset.groups.isNotEmpty)
        .toList();

    return filteredPresets
        .map(
          (preset) {
            final data = ProjectTuningTreeViewNode.preset(preset);
            return TreeItem(
              expanded: expansions.contains(data) || search.isNotEmpty,
              data: data,
              children: preset.groups.map(
                (presetGroup) {
                  final data = ProjectTuningTreeViewNode.presetGroup(
                    presetGroup,
                  );

                  return TreeItem(
                    data: data,
                    expanded: expansions.contains(data) || search.isNotEmpty,
                    children: [
                      ...presetGroup.exposedProperties.map((
                        exposedProperty,
                      ) {
                        final data = ProjectTuningTreeViewNode.exposedProperty(
                          preset,
                          exposedProperty,
                        );

                        return TreeItem(
                          expanded:
                              expansions.contains(data) || search.isNotEmpty,
                          data: data,
                        );
                      }),
                      ...presetGroup.exposedFunctions.map((
                        exposedFunction,
                      ) {
                        final data = ProjectTuningTreeViewNode.exposedFunction(
                          preset,
                          exposedFunction,
                        );

                        return TreeItem(
                          expanded:
                              expansions.contains(data) || search.isNotEmpty,
                          data: data,
                        );
                      }),
                    ],
                  );
                },
              ).toList(),
            );
          },
        )
        .toList()
        .cast<TreeNode<ProjectTuningTreeViewNode>>();
  }
}
