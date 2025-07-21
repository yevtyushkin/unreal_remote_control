import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/data/projects_repository.dart';
import 'package:unreal_remote_control/data/remote_control_api_client.dart';
import 'package:unreal_remote_control/logic/connection_status.dart';
import 'package:unreal_remote_control/logic/exposed_function.dart';
import 'package:unreal_remote_control/logic/exposed_property.dart';
import 'package:unreal_remote_control/logic/preset.dart';
import 'package:unreal_remote_control/logic/project.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';

/// Provides [ProjectsNotifier] in the app.
final projectsNotifier = ChangeNotifierProvider<ProjectsNotifier>((_) {
  return ProjectsNotifier(
    const ProjectsRepository(),
    RemoteControlApiClient(),
  );
});

/// Manages shared state of the app.
class ProjectsNotifier extends ChangeNotifier {
  ProjectsNotifier(
    this._projectsRepository,
    this._remoteControlApiClient,
  ) {
    _restoreProjects();
  }

  final ProjectsRepository _projectsRepository;

  final RemoteControlApiClient _remoteControlApiClient;

  List<Project> _projects = [];

  UnmodifiableListView<Project> get projects => UnmodifiableListView(_projects);

  Project? _selectedProject;

  Project? get selectedProject => _selectedProject;

  ConnectionStatus _connectionStatus = const ConnectionStatus.connecting();

  ConnectionStatus get connectionStatus => _connectionStatus;

  List<Preset> _presets = [];

  UnmodifiableListView<Preset> get presets => UnmodifiableListView(_presets);

  Map<String, PropertyValueWithMetaData> _propertyValues = {};

  UnmodifiableMapView<String, PropertyValueWithMetaData> get propertyValues =>
      UnmodifiableMapView(_propertyValues);

  Future<void> _restoreProjects() async {
    _projects = await _projectsRepository.fetchAll();
    notifyListeners();
  }

  Future<void> createOrUpdateProject(Project model) async {
    await _projectsRepository.save(model);

    final idx = _projects.indexWhere(
      (existingModel) => existingModel.id == model.id,
    );
    if (idx != -1) {
      _projects[idx] = model;
      _selectedProject = model;
    } else {
      _projects = [..._projects, model];
    }

    notifyListeners();
  }

  Future<void> selectProject(Project? project) async {
    _selectedProject = project;
    _connectionStatus = const ConnectionStatus.connecting();
    _presets = [];
    _propertyValues = {};

    notifyListeners();

    await connect();
  }

  Future<void> connect() async {
    final selectedProject = _selectedProject;
    if (selectedProject == null) return;

    try {
      final response = await _remoteControlApiClient.getPresets(
        selectedProject.url,
      );

      final presetResponses = await Future.wait(
        response.presets.map(
          (preset) => _remoteControlApiClient.getPreset(
            selectedProject.url,
            preset.name,
          ),
        ),
      );

      _connectionStatus = const ConnectionStatus.connected();
      _presets = presetResponses.map((response) => response.preset).toList();
    } catch (e, st) {
      final msg = '$e,\nStacktrace: $st';
      _connectionStatus = ConnectionStatus.failed(msg);
    }

    notifyListeners();
  }

  Future<void> deleteCurrentProject() async {
    final project = _selectedProject;
    if (project == null) return;

    _projects = _projects.where((p) => p.id != project.id).toList();
    await _projectsRepository.delete(project);
    await selectProject(null);

    notifyListeners();
  }

  Future<void> fetchPropertyValue(
    Preset preset,
    ExposedProperty property,
  ) async {
    final selectedProject = _selectedProject;
    if (selectedProject == null) return;

    _propertyValues[property.id] = const PropertyValueWithMetaData.loading();
    notifyListeners();

    final url = selectedProject.url;

    final response = await _remoteControlApiClient.getPropertyValue(
      url,
      preset.name,
      property.displayName,
    );

    _propertyValues[property.id] = PropertyValueWithMetaData.fromResponse(
      response,
    );
    notifyListeners();
  }

  Future<bool> sendPropertyValue(
    Preset preset,
    ExposedProperty exposedProperty,
    PropertyValueWithMetaData propertyValue,
  ) async {
    final url = _selectedProject?.url;
    if (url == null) return false;

    try {
      await _remoteControlApiClient.sendPropertyValue(
        url,
        preset.name,
        exposedProperty.displayName,
        propertyValue,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> callFunction(
    Preset preset,
    ExposedFunction function,
  ) async {
    final url = _selectedProject?.url;
    if (url == null) return false;

    try {
      await _remoteControlApiClient.callFunction(
        url,
        preset.name,
        function.displayName,
      );

      return true;
    } catch (_) {
      return false;
    }
  }
}
