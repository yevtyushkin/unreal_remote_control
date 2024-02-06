import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:unreal_remote_control/common/state/page_state_notifier.dart';
import 'package:unreal_remote_control/common/util/where_extension.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';
import 'package:unreal_remote_control/projects/domain/projects_page_state.dart';
import 'package:unreal_remote_control/projects/repository/projects_repository.dart';
import 'package:uuid/uuid.dart';

/// A notifier that manages projects page state.
class ProjectsPageNotifier extends PageStateNotifier<ProjectsPageState> {
  /// A [ProjectsRepository] this notifier uses to persist project models.
  final ProjectsRepository _projectsRepository;

  /// A [Uuid] generator this notifier uses to generate [Project] IDs.
  final Uuid _uuid;

  /// Returns the [UnmodifiableListView] of projects with the project search
  /// query applied.
  UnmodifiableListView<Project> get projects {
    return UnmodifiableListView(
      state.projects.where(
        (project) {
          return project.name.toLowerCase().contains(state.projectSearchQuery);
        },
      ).toList(),
    );
  }

  /// Returns a new instance of the [ProjectsPageNotifier] with the given
  /// initial [ProjectsPageState], [ProjectsRepository], and [Uuid].
  ProjectsPageNotifier(
    super.state,
    this._projectsRepository,
    this._uuid,
  );

  @override
  FutureOr<void> recover() async {
    final projects = await _projectsRepository.fetchAll();

    updateState((state) => state.copyWith(projects: projects));
  }

  /// Creates and saves a new [Project] with the given [name].
  Future<void> createProject(
    String name,
    String? connectionUrl,
  ) async {
    final project = Project(
      id: _uuid.v4(),
      name: name,
      connectionUrl: connectionUrl,
    );

    await _projectsRepository.persist(project.id, project);

    updateState(
      (state) => state.copyWith(
        projects: [...state.projects, project],
      ),
    );
  }

  /// Edits the [Project] with the given [id].
  Future<void> editProject(
    String id,
    String newName,
    String? newConnectionUrl,
  ) async {
    try {
      final updatedProject =
          state.projects.firstWhere((project) => project.id == id).copyWith(
                name: newName,
                connectionUrl: newConnectionUrl,
              );

      await _projectsRepository.persist(id, updatedProject);

      updateState(
        (state) => state.copyWith(
          projects: [
            ...state.projects.setWhere(
              (project) => project.id == id,
              updatedProject,
            ),
          ],
        ),
      );
    } on (StateError e,) {
      log('project $id not found');
    }
  }

  /// Deletes the [Project] with the given [id].
  Future<void> deleteProject(String id) async {
    await _projectsRepository.delete(id);

    updateState(
      (state) => state.copyWith(
        projects: [
          ...state.projects.where((project) => project.id != id),
        ],
      ),
    );
  }

  /// Sets the projects search query to the given trimmed lowercase [query].
  void setProjectsSearchQuery(String query) {
    updateState(
      (state) => state.copyWith(
        projectSearchQuery: query.toLowerCase().trim(),
      ),
    );
  }
}
