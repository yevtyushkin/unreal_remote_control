import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resizable_widget/resizable_widget.dart';

/// A widget that displays a tab of a project page split view.
class ProjectPagePresetSplitViewTab extends HookWidget {
  /// A flag that indicates whether this tab is a sub-tab.
  final bool isSubTab;

  /// Returns a new instance of the [ProjectPagePresetSplitViewTab].
  const ProjectPagePresetSplitViewTab({
    this.isSubTab = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isSubTab) {
      return const Placeholder();
    }

    final subTabs = useState(
      const <Widget>[
        ProjectPagePresetSplitViewTab(
          isSubTab: true,
        ),
      ],
    );

    return ResizableWidget(
      children: subTabs.value,
    );
  }
}
