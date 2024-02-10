import 'package:flutter/material.dart';
import 'package:unreal_remote_control/project/ui/project_page_app_bar.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_navigation.dart';

/// A widget that displays the project page.
class ProjectPage extends StatelessWidget {
  /// Returns a new instance of the [ProjectPage].
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: ProjectPageAppBar(),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ProjectPagePresetNavigation(),
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 3,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
