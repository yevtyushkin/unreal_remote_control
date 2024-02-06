import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:unreal_remote_control/dashboard/dashboard_page.dart';
import 'package:unreal_remote_control/project/ui/project_page.dart';
import 'package:unreal_remote_control/projects/ui/projects_page.dart';
import 'package:unreal_remote_control/settings/settings_page.dart';

/// The route path for [ProjectsPage].
const String projectsPageRoutePath = '/projects';

/// The route path for [SettingsPage].
const String settingsPageRoutePath = '/settings';

/// The route path for [ProjectPage].
const String projectPageRoutePath = '/project';

/// A [GlobalKey] for the root app navigator.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey();

/// A [GlobalKey] for the nested [DashboardPage] navigator.
final GlobalKey<NavigatorState> _dashboardShellNavigatorKey = GlobalKey();

/// The router of this application.
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: projectsPageRoutePath,
  routes: [
    ShellRoute(
      navigatorKey: _dashboardShellNavigatorKey,
      builder: (_, __, child) {
        return DashboardPage(child: child);
      },
      routes: [
        GoRoute(
          path: projectsPageRoutePath,
          builder: (_, __) {
            return const ProjectsPage();
          },
        ),
        GoRoute(
          path: settingsPageRoutePath,
          builder: (_, __) {
            return const SettingsPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: projectPageRoutePath,
      builder: (_, __) {
        return const ProjectPage();
      },
    ),
  ],
);
