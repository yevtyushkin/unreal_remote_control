import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unreal_remote_control/router.dart';

/// Navigation rail widget for navigation within the dashboard page.
class DashboardPageNavigationRail extends StatefulWidget {
  /// Returns a new instance of the [DashboardPageNavigationRail].
  const DashboardPageNavigationRail({
    super.key,
  });

  @override
  State<DashboardPageNavigationRail> createState() =>
      _DashboardPageNavigationRailState();
}

class _DashboardPageNavigationRailState
    extends State<DashboardPageNavigationRail> {
  /// All [NavigationRailDestination]s of this navigation rail.
  static const List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Tooltip(
        message: 'Projects',
        child: Icon(Icons.folder),
      ),
      label: Text('Projects'),
    ),
    NavigationRailDestination(
      icon: Tooltip(
        message: 'Settings',
        child: Icon(Icons.settings),
      ),
      label: Text('Settings'),
    ),
  ];

  /// Route paths of the corresponding [NavigationRailDestination] this
  /// navigation rail displays.
  static const List<String> _destinationPaths = [
    projectsPageRoutePath,
    settingsPageRoutePath,
  ];

  /// An index of the selected navigation rail destination.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      elevation: 16,
      destinations: _destinations,
      onDestinationSelected: _onDestinationSelected,
    );
  }

  /// Selects the new navigation destination identified by the given [newIndex]
  /// and pushes the corresponding route to the dashboard page router.
  void _onDestinationSelected(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });

    context.replace(_destinationPaths[newIndex]);
  }
}
