import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/exposed_function.dart';
import 'package:unreal_remote_control/logic/preset.dart';
import 'package:unreal_remote_control/logic/projects_notifier.dart';

class FunctionInvocation extends ConsumerWidget {
  const FunctionInvocation({
    required this.preset,
    required this.function,
    super.key,
  });

  final Preset preset;

  final ExposedFunction function;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (function.underlyingFunction.arguments.isNotEmpty) {
      return const Center(
        child: Text('Non-zero argument functions are not yet supported'),
      );
    }

    return Button.primary(
      child: const Text('Call'),
      onPressed: () => ref
          .read(projectsNotifier)
          .callFunction(preset, function)
          .then((applied) {
        if (applied && context.mounted) {
          showToast(
            context: context,
            location: ToastLocation.topRight,
            builder: (_, _) {
              return const SurfaceCard(
                child: Basic(
                  title: Text('Function call success!'),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
