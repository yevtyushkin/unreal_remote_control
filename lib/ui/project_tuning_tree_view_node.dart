import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/exposed_function.dart';
import 'package:unreal_remote_control/logic/exposed_property.dart';
import 'package:unreal_remote_control/logic/preset.dart';
import 'package:unreal_remote_control/logic/preset_group.dart';

part 'project_tuning_tree_view_node.freezed.dart';

@freezed
sealed class ProjectTuningTreeViewNode with _$ProjectTuningTreeViewNode {
  const factory ProjectTuningTreeViewNode.preset(
    Preset preset,
  ) = PresetNode;

  const factory ProjectTuningTreeViewNode.presetGroup(
    PresetGroup group,
  ) = PresetGroupNode;

  const factory ProjectTuningTreeViewNode.exposedProperty(
    Preset preset,
    ExposedProperty property,
  ) = ExposedPropertyNode;

  const factory ProjectTuningTreeViewNode.exposedFunction(
    Preset preset,
    ExposedFunction function,
  ) = ExposedFunctionNode;
}
