import 'package:unreal_remote_control/common/state/page_state_notifier.dart';
import 'package:unreal_remote_control/project/client/remote_control_http_client.dart';
import 'package:unreal_remote_control/project/domain/preset_information.dart';
import 'package:unreal_remote_control/project/state/project_page_state.dart';
import 'package:unreal_remote_control/projects/domain/project.dart';

/// A notifier that manages project page state.
class ProjectPageNotifier extends PageStateNotifier<ProjectPageState> {
  /// A [RemoteControlHttpClient] used by this notifier to interact with the
  /// Remote Control API.
  final RemoteControlHttpClient _client;

  /// Returns a new instance of [ProjectPageNotifier] with
  /// the given [ProjectPageState] and [RemoteControlHttpClient].
  ProjectPageNotifier(super.state, this._client);

  /// Sets the selected project to the given [project].
  Future<void> selectProject(Project project) async {
    final connectionUrl = project.connectionUrl;
    List<PresetInformation> presets = [];
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

  /// Sets the selected preset to the given [preset].
  void selectPreset(PresetInformation? preset) {
    updateState(
      (state) => state.copyWith(
        selectedPreset: preset,
      ),
    );
  }
}
