import 'package:go_router/go_router.dart';
import 'package:unreal_remote_control/ui/project_page.dart';
import 'package:unreal_remote_control/ui/project_selection_page.dart';

/// Route for the project selection page.
const String projectSelectionRoute = '/project_selection';

/// Route for the project page.
const String projectRoute = '/project';

/// [GoRouter] for managing the navigation of the application.
final GoRouter router = GoRouter(
  initialLocation: projectSelectionRoute,
  routes: [
    GoRoute(
      path: projectSelectionRoute,
      builder: (_, _) => const ProjectSelectionPage(),
    ),
    GoRoute(
      path: projectRoute,
      builder: (_, _) => const ProjectPage(),
    ),
  ],
);
