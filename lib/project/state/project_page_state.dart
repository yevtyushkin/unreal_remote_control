import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

part 'project_page_state.freezed.dart';

/// A model of the project page state.
@freezed
class ProjectPageState with _$ProjectPageState {
  /// Returns a new instance of the [ProjectPageState] with the
  /// given [selectedProject] and presets.
  const factory ProjectPageState({
    required Project? selectedProject,
    required List<Preset> presets,
    required bool problematicConnectionUrl,
    required Preset? selectedPreset,
  }) = _ProjectPageState;
}
