import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:json_editor_flutter/json_editor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';
import 'package:unreal_remote_control/ui/send_refresh_buttons.dart';

class DynamicEditor extends HookWidget {
  const DynamicEditor({
    required this.property,
    required this.onSend,
    required this.onRefresh,
    super.key,
  });

  final Dynamic property;
  final void Function(PropertyValueWithMetaData) onSend;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final state = useState(property.value);

    return Column(
      children: [
        Expanded(
          child: JsonEditor(
            json: jsonEncode(state.value),
            editors: const [Editors.text],
            hideEditorsMenuButton: true,
            enableKeyEdit: false,
            onChanged: (v) => state.value = v,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SendRefreshButtons(
            send: () => onSend(property.copyWith(value: state.value)),
            refresh: onRefresh,
          ),
        ),
      ],
    );
  }
}
