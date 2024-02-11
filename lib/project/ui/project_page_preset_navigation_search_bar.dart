import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unreal_remote_control/providers.dart';

/// A widget that displays a search bar for a project page preset navigation
/// section.
class ProjectPagePresetNavigationSearchBar extends ConsumerWidget {
  /// Returns a new instance of the [ProjectPagePresetNavigationSearchBar].
  const ProjectPagePresetNavigationSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      flexibleSpace: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => _onSearchBarTextChanged(value, ref),
      ),
    );
  }

  /// Handles the search bar text change with the given [text].
  void _onSearchBarTextChanged(String text, WidgetRef ref) {
    ref.read(projectPageNotifierProvider).updatePresetSearchQuery(text);
  }
}
