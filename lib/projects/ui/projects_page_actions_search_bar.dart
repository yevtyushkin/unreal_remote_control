import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays the search bar which allows to search a specific
/// project by its name.
class ProjectsPageActionsSearchBar extends HookConsumerWidget {
  /// Returns a new instance of [ProjectsPageActionsSearchBar].
  const ProjectsPageActionsSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQueryController = useTextEditingController();

    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffix: IconButton(
          onPressed: () => _clearSearchQuery(searchQueryController, ref),
          icon: const Icon(Icons.close),
        ),
        labelText: 'Search project',
      ),
      controller: searchQueryController,
      onChanged: (query) => _onSearchQueryChanged(query, ref),
    );
  }

  /// Clears the projects search query.
  void _clearSearchQuery(
    TextEditingController searchQueryController,
    WidgetRef ref,
  ) {
    searchQueryController.clear();

    ref.read(projectsPageNotifierProvider).setProjectsSearchQuery('');
  }

  /// Handles the given new projects search [query].
  void _onSearchQueryChanged(String query, WidgetRef ref) {
    ref.read(projectsPageNotifierProvider).setProjectsSearchQuery(query);
  }
}
