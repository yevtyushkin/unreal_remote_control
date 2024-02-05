import 'package:flutter/material.dart';
import 'package:unreal_remote_control/dashboard/dashboard_page_navigation_rail.dart';

/// A widget that displays the dashboard page.
class DashboardPage extends StatelessWidget {
  /// The child of this [DashboardPage].
  final Widget child;

  /// Returns a new instance of the [DashboardPage] with the given [child].
  const DashboardPage({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const DashboardPageNavigationRail(),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
