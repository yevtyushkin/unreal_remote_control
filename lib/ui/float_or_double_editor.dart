import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';
import 'package:unreal_remote_control/ui/send_refresh_buttons.dart';

class FloatOrDoubleEditor extends HookConsumerWidget {
  const FloatOrDoubleEditor({
    required this.property,
    required this.onSend,
    required this.onRefresh,
    super.key,
  });

  final FloatOrDouble property;
  final void Function(PropertyValueWithMetaData) onSend;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = useState(property.value);
    final controller = useTextEditingController(
      text: value.value.toStringAsPrecision(5),
    );

    final min = property.min;
    final max = property.max;

    return Column(
      children: [
        TextField(
          controller: controller,
          onSubmitted: (v) {
            final n = num.tryParse(v);
            if (n == null) {
              controller.text = value.value.toStringAsPrecision(5);
              return;
            }
            value.value = n.toDouble();
            controller.text = value.value.toStringAsPrecision(5);
          },
        ),
        if (min != null && max != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Text(min.min(value.value).toString()).small,
                Expanded(
                  child: Slider(
                    value: SliderValue.single(value.value),
                    min: min.min(value.value),
                    max: max.max(value.value),
                    onChanged: (v) {
                      value.value = v.start;
                      controller.text = value.value.toStringAsFixed(5);
                    },
                  ),
                ),
                Text(max.max(value.value).toString()).small,
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SendRefreshButtons(
            send: () => onSend(property.copyWith(value: value.value)),
            refresh: onRefresh,
          ),
        ),
      ],
    );
  }
}
