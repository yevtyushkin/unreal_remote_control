import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:unreal_remote_control/project/ui/project_page_preset_split_view_tab.dart';

/// A widget that displays the project page preset split view, where
/// each side of the view can contain multiple properties or functions.
class ProjectPagePresetSplitView extends HookWidget {
  /// Returns a new instance of the [ProjectPagePresetSplitView].
  const ProjectPagePresetSplitView({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = useState(
      const <Widget>[
        ProjectPagePresetSplitViewTab(),
      ],
    );

    return Stack(
      children: [
        ResizableWidget(
          key: ObjectKey(tabs.value),
          children: tabs.value,
        ),
        Positioned(
          left: 16.0,
          top: 16.0,
          child: Tooltip(
            message: 'Add new tab',
            child: FloatingActionButton(
              onPressed: () => _addTab(tabs),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  /// Adds the new tab to this [ProjectPagePresetSplitView].
  void _addTab(ValueNotifier<List<Widget>> tabs) {
    tabs.value = [
      ...tabs.value,
      const ProjectPagePresetSplitViewTab(),
    ];
  }
}
