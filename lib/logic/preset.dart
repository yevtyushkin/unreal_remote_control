import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/preset_group.dart';

part 'preset.freezed.dart';
part 'preset.g.dart';

/// `Preset` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/presets and
/// https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class Preset with _$Preset {
  const factory Preset({
    required String name,
    required String path,

    /// Empty when calling https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/presets.
    @Default([]) List<PresetGroup> groups,
  }) = _Preset;

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
}
