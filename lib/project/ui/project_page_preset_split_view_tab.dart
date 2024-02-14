import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resizable_widget/resizable_widget.dart';

/// A widget that displays a tab of a project page split view.
class ProjectPagePresetSplitViewTab extends HookWidget {
  /// Returns a new instance of the [ProjectPagePresetSplitViewTab].
  const ProjectPagePresetSplitViewTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final subTabs = useState(
      const <Widget>[],
    );

    return ResizableWidget(
      children: subTabs.value,
    );
  }
}
