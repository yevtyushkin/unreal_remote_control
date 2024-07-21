import 'dart:developer';

import 'package:unreal_remote_control/common/state/page_state_notifier.dart';
import 'package:unreal_remote_control/common/util/debouncer.dart';
import 'package:unreal_remote_control/common/util/where_extension.dart';
import 'package:unreal_remote_control/project/client/remote_control_http_client.dart';
import 'package:unreal_remote_control/project/domain/exposed_property.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';
import 'package:unreal_remote_control/project/state/project_page_state.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

/// A notifier that manages project page state.
class ProjectPageNotifier extends PageStateNotifier<ProjectPageState> {
  /// Returns a new instance of [ProjectPageNotifier] with
  /// the given [ProjectPageState], [RemoteControlHttpClient] and [Debouncer].
  ProjectPageNotifier(super.state, this._client, this._debouncer);

  /// A [Duration] for debouncing expensive UI updates in project page preset
  /// search bar.
  static const _presetSearchDebounceDuration = Duration(milliseconds: 300);

  /// A key for debouncing expensive UI updates in project page preset search
  /// bar.
  static const _presetSearchDebounceKey = 'presetSearchQuery';

  /// A [RemoteControlHttpClient] used by this notifier to interact with the
  /// Remote Control API.
  final RemoteControlHttpClient _client;

  /// A [Debouncer] for debouncing expensive UI updates in project page preset
  /// navigation list on project page preset navigation search bar updates.
  final Debouncer _debouncer;

  /// Returns the currently selected project with the preset search query
  /// applied.
  Preset? get selectedPreset {
    return state.selectedPreset?.copyWith(
      groups: (state.selectedPreset?.groups ?? [])
          .map((group) {
            return group.copyWith(
              exposedProperties: group.exposedProperties.where((property) {
                return property.displayName.toLowerCase().contains(state.presetSearchQuery);
              }).toList(),
              exposedFunctions: group.exposedFunctions.where((function) {
                return function.displayName.toLowerCase().contains(state.presetSearchQuery);
              }).toList(),
            );
          })
          .where(
            (group) => group.exposedProperties.isNotEmpty || group.exposedFunctions.isNotEmpty,
          )
          .toList(),
    );
  }

  /// Sets the selected project to the given [project].
  Future<void> selectProject(Project project) async {
    var presets = <Preset>[];

    final connectionUrl = project.connectionUrl;
    if (connectionUrl != null) {
      try {
        presets = (await _client.getPresets(connectionUrl)).presets;
      } catch (e) {
        log(e.toString());
      }
    }

    updateState(
      (state) => state.copyWith(
        selectedProject: project,
        presets: presets,
        selectedPreset: null,
      ),
    );
  }

  /// Fetches full preset information that has the given [preset]'s name and
  /// updates all associated information to it.
  Future<void> selectPreset(Preset? preset) async {
    if (preset == null) {
      updateState(
        (state) => state.copyWith(
          selectedPreset: null,
        ),
      );

      return;
    }

    final connectionUrl = state.selectedProject?.connectionUrl;
    if (connectionUrl != null) {
      try {
        final getPresetResponse = await _client.getPreset(
          connectionUrl,
          preset.name,
        );
        final updatedPreset = getPresetResponse.preset;

        final updatedPresets = state.presets
            .setWhere(
              (preset) => preset.id == updatedPreset.id,
              updatedPreset,
            )
            .toList();

        updateState(
          (state) => state.copyWith(
            presets: updatedPresets,
            selectedPreset: updatedPreset,
          ),
        );
      } catch (e, stacktrace) {
        log(stacktrace.toString());
        rethrow;
      }
    }
  }

  /// Fetches the property value and updates the currently selected property to the given [property].
  Future<void> selectProperty(ExposedProperty property) async {
    final connectionUrl = state.selectedProject?.connectionUrl;
    final selectedPreset = state.selectedPreset;
    if (connectionUrl != null && selectedPreset != null) {
      await _client.getProperty(connectionUrl, selectedPreset.name, property.displayName);
    }
  }

  /// Updates the preset search query to the given [value].
  void updatePresetSearchQuery(String value) {
    final trimmed = value.trim().toLowerCase();

    if (trimmed.isEmpty) {
      _debouncer.cancel(_presetSearchDebounceKey);

      updateState(
        (state) => state.copyWith(
          presetSearchQuery: trimmed,
        ),
      );

      return;
    }

    _debouncer.debounce(
      _presetSearchDebounceKey,
      _presetSearchDebounceDuration,
      () => updateState(
        (state) => state.copyWith(
          presetSearchQuery: trimmed,
        ),
      ),
    );
  }
}
