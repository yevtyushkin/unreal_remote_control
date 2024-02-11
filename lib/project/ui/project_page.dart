import 'package:flutter/material.dart';
import 'package:unreal_remote_control/project/ui/project_page_app_bar.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_split_view.dart';

/// A widget that displays the project page.
class ProjectPage extends StatelessWidget {
  /// Returns a new instance of the [ProjectPage].
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ProjectPageAppBar(),
      ),
      body: ProjectPagePresetSplitView(),
    );
  }
}
