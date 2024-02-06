import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/preset_information.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

part 'project_page_state.freezed.dart';
part 'project_page_state.g.dart';

/// A model of the project page state.
@freezed
class ProjectPageState with _$ProjectPageState {
  /// Returns a new instance of the [ProjectPageState] with the
  /// given [selectedProject] and presets.
  const factory ProjectPageState({
    required Project? selectedProject,
    required List<PresetInformation> presets,
    required bool problematicConnectionUrl,
    required PresetInformation? selectedPreset,
  }) = _ProjectPageState;

  factory ProjectPageState.fromJson(Map<String, dynamic> json) =>
      _$ProjectPageStateFromJson(json);
}
