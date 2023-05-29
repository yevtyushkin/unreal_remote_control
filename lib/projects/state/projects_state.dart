import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/projects/model/project.dart';

part 'projects_state.freezed.dart';

@freezed
class ProjectsState with _$ProjectsState {
  const factory ProjectsState({
    @Default([]) List<Project> allProjects,
    Project? selectedProject,
  }) = _ProjectsState;
}
