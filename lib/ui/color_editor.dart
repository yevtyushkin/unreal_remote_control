import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:unreal_remote_control/logic/property_value_with_metadata.dart';
import 'package:unreal_remote_control/ui/send_refresh_buttons.dart';
import 'package:unreal_remote_control/util/color_helper.dart';

class ColorEditor extends HookWidget {
  const ColorEditor({
    required this.property,
    required this.onRefresh,
    required this.onSend,
    super.key,
  });

  final Color property;
  final void Function(PropertyValueWithMetaData) onSend;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final currentColor = useState(property.color);

    final red = useTextEditingController();
    final green = useTextEditingController();
    final blue = useTextEditingController();
    final alpha = useTextEditingController();
    final hex = useTextEditingController();
    final textControllers = {
      'R': red,
      'G': green,
      'B': blue,
      'A': alpha,
      'Hex': hex,
    };

    _updateTextControllers(
      textControllers,
      currentColor.value,
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        final oldNewSize = constraints.biggest / 8;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: ColorPicker(
                    paletteType: PaletteType.hueWheel,
                    pickerColor: currentColor.value,
                    onColorChanged: (c) => currentColor.value = c,
                    colorPickerWidth: constraints.maxWidth * 0.7,
                    pickerAreaHeightPercent: 0.7,
                    labelTypes: const [],
                    portraitOnly: true,
                  ),
                ),
                Flexible(
                  child: Column(
                    spacing: 8,
                    children: [
                      Column(
                        children: [
                          const Text('Current'),
                          Container(
                            height: oldNewSize.height,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              color: property.color,
                            ),
                          ),
                          Container(
                            height: oldNewSize.height,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              color: currentColor.value,
                            ),
                          ),
                          const Text('New'),
                        ],
                      ),
                      ...['R', 'G', 'B', 'A'].map((channel) {
                        return TextField(
                          features: [
                            InputFeature.leading(
                              Text(channel).xSmall,
                            ),
                          ],
                          controller: textControllers[channel],
                          onSubmitted: (text) => _onChannelEditingComplete(
                            text,
                            channel,
                            currentColor,
                            textControllers,
                          ),
                        );
                      }),
                      if (!property.isLinear)
                        Row(
                          children: [
                            Text(currentColor.value.hex).medium,
                            IconButton.ghost(
                              icon: const Icon(LucideIcons.copy).xSmall,
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: hex.text),
                                );
                                showToast(
                                  context: context,
                                  location: ToastLocation.topRight,
                                  builder: (_, _) {
                                    return const SurfaceCard(
                                      child: Basic(
                                        title: Text('Copied to clipboard!'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SendRefreshButtons(
              send: () => onSend(
                property.copyWith(color: currentColor.value),
              ),
              refresh: onRefresh,
            ),
          ],
        );
      },
    );
  }

  /// Called when the user finishes editing a channel value.
  void _onChannelEditingComplete(
    String text,
    String channel,
    ValueNotifier<ui.Color> notifier,
    Map<String, TextEditingController> controllers,
  ) {
    final n = num.tryParse(text);

    if (n == null || n < 0 || n > 255) {
      _updateTextControllers(controllers, notifier.value);
      return;
    }

    final ui.Color newColor;
    if (property.isLinear) {
      final value = n.toDouble();
      newColor = switch (channel) {
        'R' => notifier.value.withRedLinear(value),
        'G' => notifier.value.withGreenLinear(value),
        'B' => notifier.value.withBlueLinear(value),
        'A' => notifier.value.withAlphaDouble(value),
        _ => notifier.value,
      };
    } else {
      final value = n.toInt();
      newColor = switch (channel) {
        'R' => notifier.value.withRed(value),
        'G' => notifier.value.withGreen(value),
        'B' => notifier.value.withBlue(value),
        'A' => notifier.value.withAlpha(value),
        _ => notifier.value,
      };
    }

    notifier.value = newColor;
  }

  /// Updates values of tracked text controllers.
  void _updateTextControllers(
    Map<String, TextEditingController> controllers,
    ui.Color color,
  ) {
    if (property.isLinear) {
      controllers['R']?.text = color.redLinear.toStringAsPrecision(5);
      controllers['G']?.text = color.greenLinear.toStringAsPrecision(5);
      controllers['B']?.text = color.blueLinear.toStringAsPrecision(5);
      controllers['A']?.text = color.a.toStringAsPrecision(5);
      return;
    }

    controllers['R']?.text = color.redInt.toString();
    controllers['G']?.text = color.greenInt.toString();
    controllers['B']?.text = color.blueInt.toString();
    controllers['A']?.text = color.alphaInt.toString();
    controllers['Hex']?.text = color.hex;
  }
}
