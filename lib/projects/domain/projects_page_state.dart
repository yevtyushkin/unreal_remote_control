import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

part 'projects_page_state.freezed.dart';
part 'projects_page_state.g.dart';

/// A model of the projects page state.
@freezed
class ProjectsPageState with _$ProjectsPageState {
  /// Returns a new instance of the [ProjectsPageState].
  const factory ProjectsPageState({
    required List<Project> projects,
    required String projectSearchQuery,
  }) = _ProjectsPageState;

  /// Returns a new instance of the [ProjectsPageState] from the given [json].
  factory ProjectsPageState.fromJson(Map<String, dynamic> json) =>
      _$ProjectsPageStateFromJson(json);
}
