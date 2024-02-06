import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:unreal_remote_control/project/client/remote_control_http_client.dart';
import 'package:unreal_remote_control/project/state/project_page_notifier.dart';
import 'package:unreal_remote_control/project/state/project_page_state.dart';
import 'package:unreal_remote_control/projects/domain/projects_page_state.dart';
import 'package:unreal_remote_control/projects/repository/projects_repository.dart';
import 'package:unreal_remote_control/projects/state/projects_page_notifier.dart';
import 'package:uuid/uuid.dart';

/// An HTTP client to use across the application.
final Client _httpClient = Client();

/// A [Uuid] generator to use across the application.
const Uuid _uuid = Uuid();

/// A [ChangeNotifierProvider] of [ProjectsPageNotifier].
final projectsPageNotifierProvider = ChangeNotifierProvider((_) {
  const state = ProjectsPageState(
    projects: [],
    projectSearchQuery: '',
  );
  final projectsRepository = ProjectsRepository();

  return ProjectsPageNotifier(state, projectsRepository, _uuid);
});

/// A [ChangeNotifierProvider] of [ProjectPageNotifier].
final projectPageNotifierProvider = ChangeNotifierProvider((_) {
  const state = ProjectPageState(
    selectedProject: null,
    presets: [],
    problematicConnectionUrl: false,
    selectedPreset: null,
  );
  final remoteControlHttpClient = RemoteControlHttpClient(_httpClient);

  return ProjectPageNotifier(state, remoteControlHttpClient);
});
