import 'package:flutter/material.dart';

/// A widget that displays a search bar for a project page preset navigation
/// section.
class ProjectPagePresetNavigationSearchBar extends StatelessWidget {
  /// Returns a new instance of the [ProjectPagePresetNavigationSearchBar].
  const ProjectPagePresetNavigationSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      flexibleSpace: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
