import 'package:flutter/foundation.dart';
import 'package:unreal_remote_control/common/log.dart';
import 'package:unreal_remote_control/projects/model/project.dart';
import 'package:unreal_remote_control/projects/repository/projects_repository.dart';
import 'package:unreal_remote_control/projects/state/projects_state.dart';
import 'package:uuid/uuid.dart';

class ProjectsNotifier extends ChangeNotifier {
  ProjectsNotifier(this._repository) {
    _loadProjects();
  }

  final ProjectsRepository _repository;

  final Uuid _uuid = const Uuid();

  ProjectsState _state = const ProjectsState();

  ProjectsState get state => _state;

  bool get projectSelected => false;

  Future<void> _loadProjects() async {
    final allProjects = await _repository.allProjects()
      ..sort((first, second) => first.createdAt.compareTo(second.createdAt));

    _state = _state.copyWith(
      allProjects: allProjects,
    );

    notifyListeners();
  }

  Future<void> createProject(String name) async {
    final project = Project(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
      apps: const [],
    );
    _repository.addProject(project);
    _state = _state.copyWith(
      allProjects: [..._state.allProjects, project],
    );
    notifyListeners();
  }

  Future<void> deleteProject(Project project) async {
    await _repository.deleteProject(project);
    _state = _state.copyWith(
      allProjects: _state.allProjects.where((p) => p.id != project.id).toList(),
      selectedProject: _state.selectedProject == project ? null : _state.selectedProject,
    );

    notifyListeners();
  }

  void selectProject(Project project) {
    final selectedProject = _state.selectedProject;

    if (project != selectedProject) {
      _state = _state.copyWith(
        selectedProject: project,
      );
      info("set: $state");
      notifyListeners();
    }
  }
}
