import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/exposed_property.dart';
import 'package:unreal_remote_control/logic/preset.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';
import 'package:unreal_remote_control/ui/color_editor.dart';
import 'package:unreal_remote_control/ui/dynamic_editor.dart';
import 'package:unreal_remote_control/ui/float_or_double_editor.dart';

class PropertyControl extends HookConsumerWidget {
  const PropertyControl({
    required this.preset,
    required this.property,
    super.key,
  });

  final Preset preset;

  final ExposedProperty property;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyValue = ref.watch(
      projectsNotifier.select(
        (notifier) =>
            notifier.propertyValues[property.id] ??
            const PropertyValueWithMetaData.loading(),
      ),
    );

    if (propertyValue is Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (propertyValue is Color) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: ColorEditor(
          property: propertyValue,
          onSend: (value) => _sendPropertyValue(value, ref, context),
          onRefresh: () =>
              ref.read(projectsNotifier.notifier).fetchPropertyValue(
                    preset,
                    property,
                  ),
        ),
      );
    }

    if (propertyValue is FloatOrDouble) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: FloatOrDoubleEditor(
          property: propertyValue,
          onSend: (value) => _sendPropertyValue(value, ref, context),
          onRefresh: () =>
              ref.read(projectsNotifier.notifier).fetchPropertyValue(
                    preset,
                    property,
                  ),
        ),
      );
    }

    if (propertyValue is Dynamic) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: DynamicEditor(
          property: propertyValue,
          onSend: (value) => _sendPropertyValue(value, ref, context),
          onRefresh: () =>
              ref.read(projectsNotifier.notifier).fetchPropertyValue(
                    preset,
                    property,
                  ),
        ),
      );
    }

    return const Placeholder();
  }

  Future<void> _sendPropertyValue(
    PropertyValueWithMetaData propertyValue,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final applied = await ref
        .read(projectsNotifier.notifier)
        .sendPropertyValue(preset, property, propertyValue);

    if (applied && context.mounted) {
      showToast(
        context: context,
        location: ToastLocation.topRight,
        builder: (_, _) {
          return const SurfaceCard(
            child: Basic(
              title: Text('Property applied!'),
            ),
          );
        },
      );
    }
  }
}
