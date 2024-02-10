import 'package:unreal_remote_control/common/state/page_state_notifier.dart';
import 'package:unreal_remote_control/common/util/debouncer.dart';
import 'package:unreal_remote_control/common/util/where_extension.dart';
import 'package:unreal_remote_control/project/client/remote_control_http_client.dart';
import 'package:unreal_remote_control/project/domain/preset.dart';
import 'package:unreal_remote_control/project/state/project_page_state.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

/// A notifier that manages project page state.
class ProjectPageNotifier extends PageStateNotifier<ProjectPageState> {
  /// A [RemoteControlHttpClient] used by this notifier to interact with the
  /// Remote Control API.
  final RemoteControlHttpClient _client;

  /// A [Debouncer] for debouncing expensive UI updates in project page preset
  /// navigation list on project page preset navigation search bar updates.
  final Debouncer _debouncer;

  /// Returns a new instance of [ProjectPageNotifier] with
  /// the given [ProjectPageState], [RemoteControlHttpClient] and [Debouncer].
  ProjectPageNotifier(super.state, this._client, this._debouncer);

  /// Sets the selected project to the given [project].
  Future<void> selectProject(Project project) async {
    final connectionUrl = project.connectionUrl;
    List<Preset> presets = [];
    bool problematicConnectionUrl = false;
    if (connectionUrl != null) {
      try {
        presets = (await _client.getPresets(connectionUrl)).presets;
      } catch (_) {
        problematicConnectionUrl = true;
      }
    } else {
      problematicConnectionUrl = true;
    }

    updateState(
      (state) => state.copyWith(
        selectedProject: project,
        presets: presets,
        problematicConnectionUrl: problematicConnectionUrl,
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
      } catch (_) {}
    }
  }
}
