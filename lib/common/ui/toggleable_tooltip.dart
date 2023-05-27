import 'package:fluent_ui/fluent_ui.dart';

class ToggleableTooltip extends StatelessWidget {
  const ToggleableTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.enabled = false,
  }) : super(key: key);

  final String message;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? Tooltip(
            message: message,
            triggerMode: TooltipTriggerMode.tap,
            child: child,
          )
        : child;
  }
}
