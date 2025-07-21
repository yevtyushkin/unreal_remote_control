import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unreal_remote_control/logic/exposed_function.dart';
import 'package:unreal_remote_control/logic/exposed_property.dart';

part 'preset_group.freezed.dart';
part 'preset_group.g.dart';

/// `PresetGroup` from https://dev.epicgames.com/documentation/en-us/unreal-engine/remote-control-preset-api-http-reference-for-unreal-engine#getremote/preset/insert-preset-name.
@freezed
abstract class PresetGroup with _$PresetGroup {
  const factory PresetGroup({
    required String name,
    required List<ExposedProperty> exposedProperties,
    required List<ExposedFunction> exposedFunctions,
  }) = _PresetGroup;

  factory PresetGroup.fromJson(Map<String, dynamic> json) =>
      _$PresetGroupFromJson(json);
}
